package com.edulog.notification.edta.mqtt;

import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigInteger;
import java.security.GeneralSecurityException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.SecureRandom;
import java.security.cert.Certificate;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.util.Collections;
import java.util.List;
import java.util.Properties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MQTTConnectionUtility {

    private static final Logger logger = LoggerFactory.getLogger(MQTTConnectionUtility.class);

    private MQTTConnectionUtility() {}

    public static String getConfig(String name) {
        Properties prop = new Properties();
        try (InputStream stream = MQTTConnectionUtility.class.getResourceAsStream("/mqtt-config.properties")) {
            prop.load(stream);
        } catch (IOException e) {
            return null;
        }
        String value = prop.getProperty(name);
        if (value == null || value.trim().length() == 0) {
            return null;
        } else {
            return value;
        }
    }

    public static KeyStorePasswordPair getKeyStorePasswordPair(final String certificateFile, final String privateKeyFile) {
        return getKeyStorePasswordPair(certificateFile, privateKeyFile, null);
    }

    public static KeyStorePasswordPair getKeyStorePasswordPair(final String certificateFile, final String privateKeyFile,
            String keyAlgorithm) {
        if (certificateFile == null || privateKeyFile == null) {
            logger.error("Certificate or private key file missing");
            return null;
        }
        logger.info("Cert file: {} Private key: {}", certificateFile, privateKeyFile);
        final PrivateKey privateKey = loadPrivateKeyFromFile(privateKeyFile, keyAlgorithm);

        final List<Certificate> certChain = loadCertificatesFromFile(certificateFile);

        if (certChain == null || privateKey == null)
            return null;

        return getKeyStorePasswordPair(certChain, privateKey);
    }

    public static KeyStorePasswordPair getKeyStorePasswordPair(final List<Certificate> certificates, final PrivateKey privateKey) {
        KeyStore keyStore;
        String keyPassword;
        try {
            keyStore = KeyStore.getInstance(KeyStore.getDefaultType());
            keyStore.load(null);

            // randomly generated key password for the key in the KeyStore
            keyPassword = new BigInteger(128, new SecureRandom()).toString(32);

            Certificate[] certChain = new Certificate[certificates.size()];
            certChain = certificates.toArray(certChain);
            keyStore.setKeyEntry("alias", privateKey, keyPassword.toCharArray(), certChain);
        } catch (KeyStoreException | NoSuchAlgorithmException | CertificateException | IOException e) {
            logger.error("Failed to create key store");
            return null;
        }

        return new KeyStorePasswordPair(keyStore, keyPassword);
    }

    @SuppressWarnings("unchecked")
    private static List<Certificate> loadCertificatesFromFile(final String filename) {
        try {
            final CertificateFactory certFactory = CertificateFactory.getInstance("X.509");
            return (List<Certificate>) certFactory.generateCertificates(MQTTConnectionUtility.class.getResourceAsStream(filename));
        } catch (Exception e) {
            logger.error("Failed to load certificate file {}", filename, e);
        }
        return Collections.emptyList();
    }

    private static PrivateKey loadPrivateKeyFromFile(final String filename, final String algorithm) {
        PrivateKey privateKey = null;
        try (DataInputStream stream = new DataInputStream(MQTTConnectionUtility.class.getResourceAsStream(filename))) {
            privateKey = PrivateKeyReader.getPrivateKey(stream, algorithm);
        } catch (IOException | GeneralSecurityException e) {
            logger.error("Failed to load private key from file {}", filename);
        }

        return privateKey;
    }

    public static class KeyStorePasswordPair {
        public final KeyStore keyStore;
        public final String keyPassword;

        public KeyStorePasswordPair(KeyStore keyStore, String keyPassword) {
            this.keyStore = keyStore;
            this.keyPassword = keyPassword;
        }
    }
}

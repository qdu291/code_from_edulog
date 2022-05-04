--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-06-02 14:35:04 +07

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5871 (class 0 OID 56488)
-- Dependencies: 352
-- Data for Name: config; Type: TABLE DATA; Schema: geo_master; Owner: edulog
--

INSERT INTO geo_master.config (id, application, setting, value, description) VALUES (1, 'GEOCODE', 'CENTER_LAT', '37.2865', '');
INSERT INTO geo_master.config (id, application, setting, value, description) VALUES (2, 'GEOCODE', 'CENTER_LNG', '-77.2977', '');
INSERT INTO geo_master.config (id, application, setting, value, description) VALUES (3, 'GEOCODE', 'EDIT_ZOOM', '16', 'Zoom setting level to allow editing in geocode editor');
INSERT INTO geo_master.config (id, application, setting, value, description) VALUES (4, 'GEOCODE', 'INIT_ZOOM', '12', 'Init zoom setting for geocode editor');
INSERT INTO geo_master.config (id, application, setting, value, description) VALUES (5, 'GEOCODE', 'STREET_WIDTH', '6.70561', '');


--
-- TOC entry 5873 (class 0 OID 56496)
-- Dependencies: 354
-- Data for Name: geoserver_layer; Type: TABLE DATA; Schema: geo_master; Owner: edulog
--

INSERT INTO geo_master.geoserver_layer (id, display_name, display_order, description) VALUES (1, 'Zero Speed', 1, NULL);
INSERT INTO geo_master.geoserver_layer (id, display_name, display_order, description) VALUES (2, 'No Travel', 2, NULL);
INSERT INTO geo_master.geoserver_layer (id, display_name, display_order, description) VALUES (3, 'Hazard', 3, NULL);
INSERT INTO geo_master.geoserver_layer (id, display_name, display_order, description) VALUES (4, 'One-ways', 4, NULL);
INSERT INTO geo_master.geoserver_layer (id, display_name, display_order, description) VALUES (5, 'All Streets', 5, NULL);
INSERT INTO geo_master.geoserver_layer (id, display_name, display_order, description) VALUES (6, 'No Walk', 6, NULL);
INSERT INTO geo_master.geoserver_layer (id, display_name, display_order, description) VALUES (7, 'Fat Street', 7, NULL);


--
-- TOC entry 5882 (class 0 OID 0)
-- Dependencies: 353
-- Name: config_id_seq; Type: SEQUENCE SET; Schema: geo_master; Owner: edulog
--

SELECT pg_catalog.setval('geo_master.config_id_seq', 5, true);


--
-- TOC entry 5883 (class 0 OID 0)
-- Dependencies: 355
-- Name: geoserver_layer_id_seq; Type: SEQUENCE SET; Schema: geo_master; Owner: edulog
--

SELECT pg_catalog.setval('geo_master.geoserver_layer_id_seq', 7, true);


-- Completed on 2020-06-02 14:35:04 +07

--
-- PostgreSQL database dump complete
--


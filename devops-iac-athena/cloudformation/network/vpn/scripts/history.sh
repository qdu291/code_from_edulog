    1  rm -rf $chefdir
    2  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
    3    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
    4  cd $chefdir
    5  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
    6  chef-solo -c $chefdir/solo.rb -j $chefdir/nodes/default.json >>/var/log/run-chef.log 2>&1
    7  chefdir=/tmp/initial-chef-run
    8  rm -rf $chefdir
    9  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
   10    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
   11  cd $chefdir
   12  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
   13  cd /home
   14  chefdir=/tmp/initial-chef-run
   15  rm -rf $chefdir
   16  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
   17    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
   18  cd $chefdir
   19  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
   20  chef-solo -c $chefdir/solo.rb -j $chefdir/nodes/default.json >>/var/log/run-chef.log 2>&1
   21  cd /home
   22  ls
   23  chefdir=/tmp/initial-chef-run
   24  rm -rf $chefdir
   25  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
   26    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
   27  cd $chefdir
   28  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
   29  chef-solo -c $chefdir/solo.rb -j $chefdir/nodes/default.json >>/var/log/run-chef.log 2>&1
   30  chefdir=/tmp/initial-chef-run
   31  rm -rf $chefdir
   32  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
   33    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
   34  cd $chefdir
   35  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
   36  chef-solo -c $chefdir/solo.rb -j $chefdir/nodes/default.json
   37  cd /home
   38  ls
   39  chmod 600 /root/.ssh/chef-deploy
   40  chefdir=/tmp/initial-chef-run
   41  rm -rf $chefdir
   42  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
   43    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
   44  cd $chefdir
   45  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
   46  chef-solo -c $chefdir/solo.rb -j $chefdir/nodes/default.json
   47  cd /home
   48  ls
   49  chmod 600 /root/.ssh/chef-deploy
   50  chefdir=/tmp/initial-chef-run
   51  rm -rf $chefdir
   52  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
   53    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
   54  cd $chefdir
   55  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
   56  chef-solo -c $chefdir/solo.rb -j $chefdir/nodes/default.json
   57  cd /home
   58  ls
   59  cat /etc/passwd | grep ptruong
   60  cat /etc/passwd | grep ltruong
   61  cd /etc/chef/
   62  ls -la
   63  cd /opt/karros_tech/bin/
   64  ls -la
   65  cat chef-last-run.sh
   66  cat run-chef.sh
   67  ./run-chef.sh
   68  cat run-chef.sh
   69  vi run-chef.sh
   70  ./run-chef.sh
   71  cat /etc/passwd | grep ltruong
   72  ls /root/chef/data_bags/users/
   73  ./run-chef.sh
   74  vi run-chef.sh
   75  ./run-chef.sh
   76  cat /etc/passwd | grep ltruong
   77  exit
   78  cd /opt/karros_tech/bin/
   79  ll
   80  ls -la
   81  vi run-chef.sh
   82  bash run-chef.sh
   83  cat /etc/passwd | grep atruongm
   84  bash run-chef.sh
   85  cat /etc/passwd | grep atruong
   86  exit
   87  crontab -l
   88  history
   89  less /var/log/run-chef.log.1
   90  ls /home/
   91  less /var/log/run-chef.log
   92  cat /etc/passwd| grep thong
   93  cat /etc/passwd| grep atruong
   94  cd /opt/karros_tech/bin/
   95  ls
   96  vim run-chef.sh
   97  bash run-chef.sh
   98  cat /etc/passwd| grep atruong
   99  cat /etc/passwd| grep thong
  100  cat /etc/cron.d/run-chef
  101  less /var/log/run-chef.log
  102  bash run-chef.sh
  103  cat /etc/passwd| grep thong
  104  cat /etc/passwd| grep thong
  105  cat /etc/group | grep ktvn
  106  vim run-chef.sh
  107  cat /etc/ktchef/branch
  108  bash run-chef.sh
  109  cat /etc/passwd | grep dtle
  110  bash run-chef.sh
  111  bash run-chef.sh
  112  cat /etc/passwd | grep dtle
  113  cat /etc/passwd | grep thong
  114  bash run-chef.sh
  115  ls /home/
  116  cat /etc/passwd | grep 2015
  117  less /etc/ktchef/branch
  118  bash run-chef.sh
  119  cat /etc/passwd | grep thong
  120  ls -la /root/chef/
  121  git branch
  122  cd /root/chef/
  123  git branch
  124  less data_bags/users/thong.json
  125  bash ru
  126  bash /opt/karros_tech/bin/run-chef.sh
  127  cd /opt/karros_tech/bi
  128  bash run
  129  cd bi
  130  cd /opt/karros_tech/bin/
  131  bash run-chef.sh
  132  cd /opt/karros_tech/bin/
  133  ls
  134  less run-chef.sh
  135  bash run-chef.sh
  136  cat /etc/passwd | grep hbui
  137  bash run-chef.sh
  138  cat /etc/passwd | grep hbui
  139  cat /etc/passwd | grep hbui
  140  cat /etc/passwd | grep hbui
  141  bash run-chef.sh
  142  cat /etc/ktchef/branch
  143  cat /etc/passwd | grep hbui
  144  bash run-chef.sh
  145  cat /etc/passwd | grep hb
  146  sudo chef-solo -c $chefdir/solo.rb -j $chefdir/nodes/default.json
  147  chefdir=/tmp/initial-chef-run
  148  sudo chef-solo -c $chefdir/solo.rb -j $chefdir/nodes/default.json
  149  sudo chef-solo -c $chefdir/solo.rb -j $chefdir/nodes/default.json
  150  rm -rf $chefdir
  151  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
  152    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
  153  cd $chefdir
  154  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
  155  cat << EOT >> solo.rb
  156  environment_path '$chefdir/environments'
  157  EOT
  158  chef-solo -c $chefdir/solo.rb -j  $chefdir/nodes/default.json
  159  ls /home
  160  rm -rf $chefdir
  161  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
  162    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
  163  cd $chefdir
  164  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
  165  cat << EOT >> solo.rb
  166  environment_path '$chefdir/environments'
  167  EOT
  168  chef-solo -c $chefdir/solo.rb -j  $chefdir/nodes/default
  169  chef-solo -c $chefdir/solo.rb -j  $chefdir/nodes/default
  170  cd ..
  171  cd ..
  172  rm -rf $chefdir
  173  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
  174    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
  175  cd $chefdir
  176  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
  177  cat << EOT >> solo.rb
  178  environment_path '$chefdir/environments'
  179  EOT
  180  chef-solo -c $chefdir/solo.rb -j  $chefdir/nodes/default
  181  ls
  182  chef-solo -c $chefdir/solo.rb -j  $chefdir/nodes/default.json
  183  cd ~
  184  rm -rf $chefdir
  185  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
  186    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
  187  cd $chefdir
  188  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
  189  cat << EOT >> solo.rb
  190  environment_path '$chefdir/environments'
  191  EOT
  192  chef-solo -c $chefdir/solo.rb -j  $chefdir/nodes/default.json
  193  cd ~
  194  rm -rf $chefdir
  195  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
  196    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
  197  cd $chefdir
  198  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
  199  cat << EOT >> solo.rb
  200  environment_path '$chefdir/environments'
  201  EOT
  202  chef-solo -c $chefdir/solo.rb -j  $chefdir/nodes/default.json
  203  chef-solo -c $chefdir/solo.rb -j  $chefdir/nodes/default_base.json
  204  cd ~
  205  chefdir=/tmp/initial-chef-run
  206  rm -rf $chefdir
  207  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
  208    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
  209  cd $chefdir
  210  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
  211  cat << EOT >> solo.rb
  212  environment_path '$chefdir/environments'
  213  EOT
  214  chef-solo -c $chefdir/solo.rb -j  $chefdir/nodes/default_base.json
  215  cd ~
  216  chefdir=/tmp/initial-chef-run
  217  rm -rf $chefdir
  218  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
  219    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
  220  cd $chefdir
  221  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
  222  cat << EOT >> solo.rb
  223  environment_path '$chefdir/environments'
  224  EOT
  225  chef-solo -c $chefdir/solo.rb -j  $chefdir/nodes/default_base.json
  226  less /opt/karros_tech/bin/run-chef.sh
  227  ls
  228  vim /etc/ktchef/branch
  229  cat /etc/passwd| grep dtle
  230  sh run-chef.sh
  231  cat /etc/passwd| grep dtle
  232  cat /etc/passwd| grep dtle
  233  vim run-chef.sh
  234  bash run-chef.sh
  235  cat /etc/passwd| grep dtle
  236  cd /root/chef/
  237  git branch
  238  git fetch
  239  git branch
  240  git checkout Devops-KP-3367
  241  ls
  242  bash /opt/karros_tech/bin/run-chef.sh
  243  cd /opt/karros_tech/bin/
  244  sh run-chef.sh
  245  vim run-chef.sh
  246  bash run-chef.sh n
  247  vim run-chef.sh
  248  vim /etc/ktchef/branch
  249  bash run-chef.sh
  250  cat /etc/passwd| grep dtle
  251  cat /etc/passwd| grep dtle
  252  cat /etc/group | grep ktvn
  253  cat /etc/group | grep ktvn
  254  less /var/log/run-chef.log
  255  less /etc/group
  256  visudo
  257  less /etc/sudoers
  258  less /etc/sudoers.d/90-cloud-init-users
  259  cat /etc/passwd | grep dtle
  260  cat /etc/passwd | less
  261  vi /etc/ktchef/branch
  262  sh /opt/karros_tech/bin/run-chef.sh
  263  cat /etc/passwd | grep dtle
  264  cat /etc/passwd | grep qhle
  265  cat /etc/passwd | grep qhle
  266  cat /etc/passwd | grep qhlee
  267  ls /opt/karros_tech/bin/
  268  ls
  269  cd /opt/karros_tech/bin/
  270  bash run-chef.sh n
  271  less run-chef.sh
  272  bash run-chef.sh
  273  cat /etc/passwd | grep qhlee
  274  cat /etc/passwd | grep qhle
  275  bash run-chef.sh
  276  cat /etc/passwd | grep qhle
  277  cat /etc/passwd | grep qhlee
  278  bash run-chef.sh
  279  bash run-chef.sh
  280  locate Collector
  281  locate Collecto
  282  service logicmonitor-agent start
  283  service logicmonitor-watchdog status
  284  service logicmonitor-agent status
  285  htop
  286  htop
  287  service logicmonitor-agent status
  288  htop
  289  cd /opt/karros_tech/bin/
  290  bash run-chef.sh
  291  cat /etc/passwd | grep dnguyen
  292  cd /opt/karros_tech/bin/
  293  ls
  294  cat /etc/passwd | grep ltruong
  295  bash run-chef.sh
  296  cat /etc/passwd | grep ltruong
  297  userdell -R ltruong
  298  userdel -R ltruong
  299  userdel -r ltruong
  300  cat /etc/passwd | grep ltruong
  301  df -h
  302  htop
  303  cd /opt/karros_tech/bin/
  304  bash run-chef.sh
  305  less /etc/passwd
  306  bash run-chef.sh
  307  bash run-chef.sh
  308  apt-get install net-utils
  309  apt-get install net-tools
  310  route -n
  311  less /var/log/run-chef.log
  312  crontab -l
  313  less /var/spool/cron/crontabs/root
  314  less /etc/cron.d/run-chef
  315  less  /opt/karros_tech/bin/run-chef.sh
  316  less /etc/ktchef/branch
  317  less  /opt/karros_tech/bin/run-chef.sh
  318  cd /opt/karros_tech/bu
  319  cd /opt/karros_tech/bin/
  320  bash run-chef.sh
  321  bash run-chef.sh
  322  chefdir=/tmp/initial-chef-run
  323  rm -rf $chefdir
  324  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
  325    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
  326  cd $chefdir
  327  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
  328  cat << EOT >> solo.rb
  329  environment_path '$chefdir/environments'
  330  EOT
  331  chef-solo -c $chefdir/solo.rb -j $chefdir/nodes/default.json
  332  cd /opt/karros_tech/bin/
  333  bash run-chef.sh
  334  cat /etc/passwd | grep ktvn
  335  ps -ef| grep openvpn
  336  vi /etc/openvpn/server.conf
  337  /etc/init.d/openvpn -h
  338  /etc/init.d/openvpn restart
  339  less /etc/openvpn/server.conf
  340  /etc/init.d/openvpn restart
  341  less /etc/openvpn/server.conf
  342  ping 172.23.55.152
  343  ssh
  344  vi /etc/openvpn/server.conf
  345  /etc/init.d/openvpn restart
  346  ssh 172.25.32.10
  347  nc -vz 172.25.32.10 22
  348  nc -vz 172.25.57.102 22
  349  nc -vz 172.25.57.102 22
  350  /etc/init.d/openvpn status
  351  /etc/init.d/openvpn restart
  352  nc -vz 172.25.57.102 22
  353  vi /etc/openvpn/server.conf
  354  nc -vz 172.25.57.102 22
  355  nc -vz 172.22.34.176 22
  356  nc -vz 172.25.57.102 22
  357  nc -vz 172.25.57.102 22
  358  less /etc/passwd| grep sndo
  359  userdel -R sndo
  360  userdel -r sndo
  361  less /etc/passwd| grep sndo
  362  less /etc/passwd| grep sndo
  363  history
  364  exit
  365  vi /etc/openvpn/server.conf
  366  /etc/init.d/openvpn status
  367  /etc/init.d/openvpn restart
  368  history
  369  chefdir=/tmp/initial-chef-run
  370  rm -rf $chefdir
  371  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
  372    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
  373  cd $chefdir
  374  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
  375  cat << EOT >> solo.rb
  376  environment_path '$chefdir/environments'
  377  EOT
  378  chef-solo -c $chefdir/solo.rb -j $chefdir/nodes/default_with_systemd.json  -E p01usw2demo
  379  chefdir=/tmp/initial-chef-run
  380  rm -rf $chefdir
  381  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
  382    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
  383  cd $chefdir
  384  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
  385  cat << EOT >> solo.rb
  386  environment_path '$chefdir/environments'
  387  EOT
  388  chef-solo -c $chefdir/solo.rb -j $chefdir/nodes/default_with_systemd.json  -E p01usw2demo
  389  cd ~
  390  chefdir=/tmp/initial-chef-run
  391  rm -rf $chefdir
  392  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
  393    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
  394  cd $chefdir
  395  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
  396  cat << EOT >> solo.rb
  397  environment_path '$chefdir/environments'
  398  EOT
  399  chef-solo -c $chefdir/solo.rb -j $chefdir/nodes/default_with_systemd.json  -E p01usw2demo
  400  ls /home
  401  exit
  402  test -d /root/.ssh || mkdir -m 0700 /root/.ssh
  403  cat << END_OF_KEY >> /root/.ssh/chef-deploy
  404  -----BEGIN RSA PRIVATE KEY-----
  405  MIIEowIBAAKCAQEA0fqG462DHOjcC5JZ5AZW4TO5HN9VYsnidue+y0nPZdLsTonq
  406  R9gDhtO6yCPRdQajJcY/YyFImQ7A8cqencc4mlCZP2lVErpoZsbqT//jg9CpR/aw
  407  YuM2ZIkLp8PGGVm7Hb79eKzq8B6288V0KeSAdtqjK7lXZH7jCEYw4KXtQoidwLjr
  408  bGragVxjujFfdiv6d2ClXV/r5fvWNh7lmA+AbX0JlOijq/lzVV34i4DtMh2f+0j+
  409  /DEha4i+QgoLQhvMLawQsAP5CuaGE2X0YzNm3WBepHFcnQzQafnnhbgcoYvHlbyQ
  410  p6NcT2CILKWtVH1Bw0gzOwdjbB+sg1AH7cuaOQIDAQABAoIBAEbUhonortCisA9r
  411  N81WYhonU2ss3uWrCixn8hEq/b3wT2wS06eWc2IYq+n1QyOBsKj+XcV3pcCTnHwz
  412  iBva5voO9BLS2jKuFKeOs912iO2fBmtTCJ7i3Cc/n2HhBULp5Nec5G2/jqSfB8Hl
  413  OlEjVj5BdEc8hwFMWBMjcjtlXUpSpL3/NBdKDL0zpFE/YibbFdospfMQTNUL6AeQ
  414  B04dZ79AhIHTWgJnHp//fOBCFeG+EjkOvznecqDEXhgXYe4qEM4F3WEoGBXjrzOS
  415  ADQtRGhgA4xsnsFEImOvxiVxYuFtjksoFF77bhMjiLptQMX/TP9NN7NT8RZiTD9o
  416  vuDa/M0CgYEA7x/XZB6KlDQYhpO0tkxKUObHqWSic8OUr/AeOfTr5fcY9i+dbOPw
  417  LVzob8j7B5eZzx6DF7pP4VpBBBAoyD4HCtn2LAn1YLdZwhj0Oz2jl5V5bbIASFy9
  418  M2lvJTc45yMa/33YFw7/FEntJJ9lAAvaRfdJ1kT1lZHy73UDtI2bf0MCgYEA4Mwf
  419  GT3k3Cf/AL+o3mfmxcVTysV47Z8Zj/WFSWECQSNS/3xRCmjVz7DM7iVk1ZE0gSrD
  420  1rywpKBIPQtEPHSO3fmZNGloJvspfSDvF2UGybEdDj1OAz3PnIp+QSbjEk3nTnup
  421  bBfcxKOdkJ8qzMRYa3TLHB5EnM6XGv8d5eElEtMCgYBCqV/Ee3cqhbNooPi58V6u
  422  WwfCQ1m+aAGlYo0qnwq8WzxMNU3vs0ObgdESiLbikPLB+MGW9cubCSwi09ZqrFAO
  423  SGEGOeh8A+Ez6Pz9HtviQDtPx1Wo1qGwGW5ws4pbdT/rhcud8gJOR6WilgT0FFnP
  424  M3cUErlb7woIk1hrFycIPQKBgAzN87OHYALeUFslj6PjfTSkscoqB2JZnqYhkQ8F
  425  9I/rSC3/UcprAErNQk8KWD0GAVyeJ/uSUel+q762ZpOe/AhO0Fg47NLTmaBkANpv
  426  SbyxVvtZqJjsq2e6R8jEQ0jmoRdKWfMrRMr6mt4DAvgY8wRj6bHXU4cvCVJjV7uh
  427  YHA7AoGBAMMk3GcGZqiQ/yaiQbKmZ/aTJ7R8Grc9SG7rclqKXzFxqoMXcQXhtjR5
  428  9h8ttsdA2srxiYvqWyKlI1TGW3e1xNEtuQ64KF7GEBqJWJbQAqRp2yEaMcVzD30u
  429  suSQdWcrToYofCk08mRkLpFfJp4Jz8ch6jmJjxjomzpA9G8mBvMf
  430  -----END RSA PRIVATE KEY-----
  431  END_OF_KEY
  432  chmod 600 /root/.ssh/chef-deploy
  433  chefdir=/tmp/initial-chef-run
  434  rm -rf $chefdir
  435  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
  436    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
  437  cd $chefdir
  438  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
  439  cat << EOT >> solo.rb
  440  environment_path '$chefdir/environments'
  441  EOT
  442  cd ~
  443  test -d /root/.ssh || mkdir -m 0700 /root/.ssh
  444  cat << END_OF_KEY >> /root/.ssh/chef-deploy
  445  -----BEGIN RSA PRIVATE KEY-----
  446  MIIEowIBAAKCAQEA0fqG462DHOjcC5JZ5AZW4TO5HN9VYsnidue+y0nPZdLsTonq
  447  R9gDhtO6yCPRdQajJcY/YyFImQ7A8cqencc4mlCZP2lVErpoZsbqT//jg9CpR/aw
  448  YuM2ZIkLp8PGGVm7Hb79eKzq8B6288V0KeSAdtqjK7lXZH7jCEYw4KXtQoidwLjr
  449  bGragVxjujFfdiv6d2ClXV/r5fvWNh7lmA+AbX0JlOijq/lzVV34i4DtMh2f+0j+
  450  /DEha4i+QgoLQhvMLawQsAP5CuaGE2X0YzNm3WBepHFcnQzQafnnhbgcoYvHlbyQ
  451  p6NcT2CILKWtVH1Bw0gzOwdjbB+sg1AH7cuaOQIDAQABAoIBAEbUhonortCisA9r
  452  N81WYhonU2ss3uWrCixn8hEq/b3wT2wS06eWc2IYq+n1QyOBsKj+XcV3pcCTnHwz
  453  iBva5voO9BLS2jKuFKeOs912iO2fBmtTCJ7i3Cc/n2HhBULp5Nec5G2/jqSfB8Hl
  454  OlEjVj5BdEc8hwFMWBMjcjtlXUpSpL3/NBdKDL0zpFE/YibbFdospfMQTNUL6AeQ
  455  B04dZ79AhIHTWgJnHp//fOBCFeG+EjkOvznecqDEXhgXYe4qEM4F3WEoGBXjrzOS
  456  ADQtRGhgA4xsnsFEImOvxiVxYuFtjksoFF77bhMjiLptQMX/TP9NN7NT8RZiTD9o
  457  vuDa/M0CgYEA7x/XZB6KlDQYhpO0tkxKUObHqWSic8OUr/AeOfTr5fcY9i+dbOPw
  458  LVzob8j7B5eZzx6DF7pP4VpBBBAoyD4HCtn2LAn1YLdZwhj0Oz2jl5V5bbIASFy9
  459  M2lvJTc45yMa/33YFw7/FEntJJ9lAAvaRfdJ1kT1lZHy73UDtI2bf0MCgYEA4Mwf
  460  GT3k3Cf/AL+o3mfmxcVTysV47Z8Zj/WFSWECQSNS/3xRCmjVz7DM7iVk1ZE0gSrD
  461  1rywpKBIPQtEPHSO3fmZNGloJvspfSDvF2UGybEdDj1OAz3PnIp+QSbjEk3nTnup
  462  bBfcxKOdkJ8qzMRYa3TLHB5EnM6XGv8d5eElEtMCgYBCqV/Ee3cqhbNooPi58V6u
  463  WwfCQ1m+aAGlYo0qnwq8WzxMNU3vs0ObgdESiLbikPLB+MGW9cubCSwi09ZqrFAO
  464  SGEGOeh8A+Ez6Pz9HtviQDtPx1Wo1qGwGW5ws4pbdT/rhcud8gJOR6WilgT0FFnP
  465  M3cUErlb7woIk1hrFycIPQKBgAzN87OHYALeUFslj6PjfTSkscoqB2JZnqYhkQ8F
  466  9I/rSC3/UcprAErNQk8KWD0GAVyeJ/uSUel+q762ZpOe/AhO0Fg47NLTmaBkANpv
  467  SbyxVvtZqJjsq2e6R8jEQ0jmoRdKWfMrRMr6mt4DAvgY8wRj6bHXU4cvCVJjV7uh
  468  YHA7AoGBAMMk3GcGZqiQ/yaiQbKmZ/aTJ7R8Grc9SG7rclqKXzFxqoMXcQXhtjR5
  469  9h8ttsdA2srxiYvqWyKlI1TGW3e1xNEtuQ64KF7GEBqJWJbQAqRp2yEaMcVzD30u
  470  suSQdWcrToYofCk08mRkLpFfJp4Jz8ch6jmJjxjomzpA9G8mBvMf
  471  -----END RSA PRIVATE KEY-----
  472  END_OF_KEY
  473  chmod 600 /root/.ssh/chef-deploy
  474  chefdir=/tmp/initial-chef-run
  475  rm -rf $chefdir
  476  GIT_SSH_COMMAND="ssh -i /root/.ssh/chef-deploy -o UserKnownHostsFile=/dev/null \
  477    -o StrictHostKeyChecking=no" git clone git@github.com:eduloginc/chef $chefdir
  478  cd $chefdir
  479  echo "cookbook_path '$chefdir/cookbooks'" > solo.rb
  480  cat << EOT >> solo.rb
  481  environment_path '$chefdir/environments'
  482  EOT
  483  ls
  484  chef-solo -c $chefdir/solo.rb -j $chefdir/nodes/default_with_systemd.json  -E p01usw2demo >>/var/log/run-chef.log 2>&1
  485  ls
  486  history
root@ip-10-40-9-214:~#
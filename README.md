# Deployment of an InfluxDb platform (TICK stack) with docker compose.

This solution provides a basis for quickly deploying a local monitoring system for testing. Not to be used in production !

This stack is composed of:
* Telegram
* InfluxDB2
* Chronograph
* Kapacitor

## Installing and configuring rsyslog
```
sudo apt install rsyslog
sudo vim /etc/rsyslog.d/50-telegraf.conf
```

Contents of the file "50-telegraf.conf”
```
$ActionQueueType LinkedList # use asynchronous processing
$ActionQueueFileName srvrfwd # set file name, also enables disk mode
$ActionResumeRetryCount -1 # infinite retries on insert failure
$ActionQueueSaveOnShutdown on # save in-memory data if rsyslog shuts down

# forward over tcp with octet framing according to RFC 5425
*.* @@(o)127.0.0.1:6514;RSYSLOG_SyslogProtocol23Format

# uncomment to use udp according to RFC 5424
#*.* @127.0.0.1:6514;RSYSLOG_SyslogProtocol23Format
```

Enabling the rsyslog service
```
sudo systemctl enable rsyslog
sudo systemctl start rsyslog
```

## Deploying the TICK stack

```
git clone https://github.com/dma65ml/tick-stack.git
cd  tick-stack
# The init.sh file can be modified to customize the installation
./init.sh
```

## Configuring the Chronograf environment

After initializing the stack, access the Chronograf page http://ipadress:8888/ to finalize the installation.

In the Configuration section select “InfluxDB Connection”.

![InfluxDB Connection](assets/images/Config1.png?raw=true)

Enable “InfluxDB v2 Auth” mode, report information from the .env file. For "Default Retention Policy" enter "autogen”. 

![InfluxDB v2 Auth](assets/images/Config2.png?raw=true)

Select preconfigured Dashboards in Telegraf

![Dashboards](assets/images/Config3.png?raw=true)

Indicate the URL of the kapacitor container "[http://kapacitor:9092](http://kapacitor:9092/)"

![Kapacitor](assets/images/Config4.png?raw=true)

Congratulations your TICK stack is configured

![Congratulations](assets/images/Config5.png?raw=true)

## Exploitation of the TICK stack
Once started, two pages are accessible from your browser:
* Chronograph http://ipadress:8888/
* InfluxDB http://ipadress:8086/

The **docker compose down** command stops the stack,

The command **docker compose up -d** restarts it.

The **clean.sh** script deletes the stack and volumes


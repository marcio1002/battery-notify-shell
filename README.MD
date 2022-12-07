# Battery Notify

<p>Get notification about battery status in linux in a customized way</p>

<div align='center'>
    <img 
        src='./assets/battery notify.png'
        alt='Imagem de notificação da bateria cheia'
    />
</div>

- [Installation](#Installation)
- [Configuration](#custom-settings)

## Installation

```bash
    sudo chmod +x ./install.sh && ./install.sh
```

## Custom settings

You can customize battery percentage in critical and maximum mode. You just need to edit the crontab with the command `crontab -e`

```bash
NOTIFY_PERCENT_CRITICAL=20 #default 30
NOTIFY_PERCENT_LOW=80 #default 90
```

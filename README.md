doctl setup

1)Create a DigitalOcean API token for your account with read and write access from the Applications & API page in the control panel. The token string is only displayed once, so save it in a safe place.
2)If you installed doctl using the Ubuntu Snap package, you may need to first create the user configuration directory if it does not exist yet by running mkdir ~/.config.
3)Use the API token to grant account access to doctl

doctl auth init --context <yourdesiredNAME> 
doctl auth list
doctl auth switch --context <yourdesiredNAME>

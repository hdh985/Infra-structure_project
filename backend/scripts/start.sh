
#!/bin/bash
cd /home/ec2-user/app
nohup java -jar build/libs/backend-0.0.1-SNAPSHOT.jar > app.log 2>&1 &

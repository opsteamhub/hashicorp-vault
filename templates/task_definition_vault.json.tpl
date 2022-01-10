
[
  {
    "essential": true,
    "memory": ${memory},
    "name": "vault",
    "cpu": ${cpu},
    "image": "${image_vault}", 
    "environment": [
      {
        "name": "VAULT_ADDR",
        "value": "http://127.0.0.1:8200"
      },
      {
        "name": "VAULT_API_ADDR",
        "value": "http://127.0.0.1:8200"
      },
      {
        "name": "VAULT_DISABLE_MLOCK",
        "value": "${disable_mlock}"
      },
      {
        "name": "VAULT_AWSKMS_SEAL_KEY_ID",
        "value": "${kms_id}"
      },
      {
        "name": "VAULT_SEAL_TYPE",
        "value": "${seal_type}"
      },
      {
        "name": "AWS_DYNAMODB_TABLE",
        "value": "${dynamodb_table}"
      }                                         
    ],
    "portMappings": [
        {
             "containerPort": 8200,
             "hostPort": 8200,
             "protocol": "tcp"
        }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "${awslogs_group}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "ecs"
      }
    },         
    "privileged": false,
    "readonlyRootFilesystem": false,
    "dnsServers": [],
    "dnsSearchDomains": [],
    "dockerSecurityOptions": [],
    "pseudoTerminal": false                  
  }
]

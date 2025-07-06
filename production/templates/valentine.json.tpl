[
    {
        "image": "${image}",
        "linuxParameters": {
            "capabilities": {
                "drop": [
                    "ALL"
                ],
                "add": []
            }
        },
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${awslogs-group}",
                "awslogs-region": "${awslogs-region}",
                "awslogs-stream-prefix": "${awslogs-stream-prefix}"
            }
        },
        "name": "valentine",
        "portMappings": [
            {
                "containerPort": 4000,
                "hostPort": 4000,
                "protocol": "tcp"
            }
        ],
        "environment": [
            {
                "name": "PHX_HOST",
                "value": "${PHX_HOST}"
            }
        ],
        "secrets": [
            {
                "name": "AZURE_OPENAI_ENDPOINT",
                "valueFrom": "${AZURE_OPENAI_ENDPOINT}"
            },
            {
                "name": "AZURE_OPENAI_KEY",
                "valueFrom": "${AZURE_OPENAI_KEY}"
            },
            {
                "name": "DATABASE_URL",
                "valueFrom": "${DATABASE_URL}"
            },
            {
                "name": "GOOGLE_CLIENT_ID",
                "valueFrom": "${GOOGLE_CLIENT_ID}"
            },
            {
                "name": "GOOGLE_CLIENT_SECRET",
                "valueFrom": "${GOOGLE_CLIENT_SECRET}"
            },
            {
                "name": "SECRET_KEY_BASE",
                "valueFrom": "${SECRET_KEY_BASE}"
            }
        ],
        "ulimits": [
            {
                "hardLimit": 1000000,
                "name": "nofile",
                "softLimit": 1000000
            }
        ],
        "cpu": 0,
        "essential": true,
        "mountPoints": [],
        "systemControls": [],
        "volumesFrom": []
    }
]
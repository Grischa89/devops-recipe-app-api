resource "aws_ecs_task_definition" "api" {
  // ... existing configuration ...

  container_definitions = jsonencode([
    {
      name  = "api"
      // ... existing api container configuration ...
      user = "1000:1000"
      linuxParameters = {
        initProcessEnabled = true
        shared_memory_size = 128
      }
      mountPoints = [
        {
          sourceVolume  = "tmp",
          containerPath = "/tmp",
          readOnly      = false
        },
        {
          sourceVolume  = "static",
          containerPath = "/vol/web/static",
          readOnly      = false
        },
        {
          sourceVolume  = "media",
          containerPath = "/vol/web/media",
          readOnly      = false
        }
      ]
      volumesFrom = []
    },
    // ... proxy container ...
  ])

  volumes = [
    {
      name = "tmp"
      ephemeral_storage = {
        size_in_gib = 20
      }
    },
    {
      name = "static"
      efs_volume_configuration = {
        file_system_id = aws_efs_file_system.static.id
        root_directory = "/static"
      }
    },
    {
      name = "media"
      efs_volume_configuration = {
        file_system_id = aws_efs_file_system.media.id
        root_directory = "/media"
      }
    }
  ]

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture       = "X86_64"
  }
} 
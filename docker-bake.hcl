group "default" {
  targets = ["native","crossbuild"]
}

variable "NAME" {
  default = "$NAME"
}

variable "EMAIL" {
  default = "$EMAIL"
}

variable "CHANGE" {
  default = "$CHANGE"
}

variable "BPO_N" {
  default = "1"
}

target "base" {
  args = {
    NAME = NAME
    EMAIL = EMAIL
    CHANGE = CHANGE
    BPO_N = BPO_N
  }
  output = ["type=local,dest=artifacts"]
}

target "native" {
  inherits = ["base"]
  target = "native-binaries"
}

target "crossbuild" {
  args = {
    ARCH = arch
  }
  inherits = ["base"]
  matrix = {
    arch = ["armhf", "arm64"]
  }
  name = "crossbuild-${arch}"
  target = "crossbuild-binaries"
}

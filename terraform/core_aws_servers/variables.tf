variable "masters_configuration" {
  type        = map(object({
    name              = string
    aws_az            = string
    aws_volume_type   = string
    aws_volume_size   = number
    aws_delete_on_termination = string
    
  }))
}

variable "aws_minions_volume_type" {
  type        = string
}

variable "aws_minions_volume_size" {
  type        = number
}

variable "aws_minions_delete_on_termination" {
  type        = string
}


variable "ssh_public_key_file" {

}

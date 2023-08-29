variable "department_abbreviation" {
  type        = string
  default = "corp"
  description = "Two-letter abbreviation for the department."
}

variable "major_environment" {
  type        = string
  default = "le"
  description = "Major environment (e.g., LE, Prod)."
}

variable "project" {
  type        =  string
  default = "nafperf"
  description = "Project name."
}

variable "specific_environment" {
  type        = string
  default = "web"
  description = "Specific environment or subproject."
}

variable "tag_owner" {
  type        = string
  default = "Jeff Farinich"
  description = "Owner tag for resource tagging."
}

variable "tag_department" {
  type        = string
  default = "technology services"
  description = "Department tag for resource tagging."
}


variable "runtime_stack" {
  type        = string
  default     = "dotnet|5.0"
  description = "Runtime stack for the App Service (e.g., dotnet|5.0)."
}

variable "PAT_TOKEN" {
  type = string
  default = "ka4mgn3yyaio3teghpngqlhcfnxupih5aiorgnd2f4dzbmcnramq"
  description = "pat token"
}

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

#variable "resource_type_abbreviation" {
#  type        = string
#  description = "Resource type abbreviation."
#}

#variable "location" {
#  type        = string
#  default     = "West US 3"
#  description = "Azure region where resources will be deployed."
#}

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

# Additional variables specific to certain resources may be defined here.
#variable "pricing_tier" {
#  type        = string
#  default     = "S1"
#  description = "Pricing tier for the App Service Plan."
#}

#variable "operating_system" {
#  type        = string
#  default     = "Windows"
#  description = "Operating system for the App Service Plan (Windows/Linux)."
#}

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
# Add any additional variables as needed for other resources.

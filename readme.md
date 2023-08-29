Commit: 8fa2b996fb22953979fc18ef09b99cf2ea26e3ed
8fa2b99 changes as asked
diff --git a/storage_account.tf b/storage_account.tf
index d1bc9fe..2091e82 100644
--- a/storage_account.tf
+++ b/storage_account.tf
@@ -1,8 +1,8 @@
 locals {
-  resource_type_abbreviation_local_storage = "SA"  # Renamed local variable for storage_account.tf
-  location_local_storage                   = "West US 3"  # Renamed local variable for storage_account.tf
+  resource_type_abbreviation_local_storage = "SA"
+  location_local_storage                   = "West US 3"  
 }
 
 resource "azurerm_storage_account" "storage_account" {
   name                     = "${var.department_abbreviation}${var.major_environment}${var.project}${var.specific_environment}${local.resource_type_abbreviation_local_storage}"
   location            = data.azurerm_resource_group.CORP-LE-NafNet-RG.location
diff --git a/variables.tf b/variables.tf
index b1b1ccc..60bd2e4 100644
--- a/variables.tf
+++ b/variables.tf
@@ -20,21 +20,10 @@ variable "specific_environment" {
   type        = string
   default = "web"
   description = "Specific environment or subproject."
 }
 
-#variable "resource_type_abbreviation" {
-#  type        = string
-#  description = "Resource type abbreviation."
-#}
-
-#variable "location" {
-#  type        = string
-#  default     = "West US 3"
-#  description = "Azure region where resources will be deployed."
-#}
-
 variable "tag_owner" {
   type        = string
   default = "Jeff Farinich"
   description = "Owner tag for resource tagging."
 }
@@ -43,22 +32,10 @@ variable "tag_department" {
   type        = string
   default = "technology services"
   description = "Department tag for resource tagging."
 }
 
-# Additional variables specific to certain resources may be defined here.
-#variable "pricing_tier" {
-#  type        = string
-#  default     = "S1"
-#  description = "Pricing tier for the App Service Plan."
-#}
-
-#variable "operating_system" {
-#  type        = string
-#  default     = "Windows"
-#  description = "Operating system for the App Service Plan (Windows/Linux)."
-#}
 
 variable "runtime_stack" {
   type        = string
   default     = "dotnet|5.0"
   description = "Runtime stack for the App Service (e.g., dotnet|5.0)."
@@ -67,6 +44,5 @@ variable "runtime_stack" {
 variable "PAT_TOKEN" {
   type = string
   default = "ka4mgn3yyaio3teghpngqlhcfnxupih5aiorgnd2f4dzbmcnramq"
   description = "pat token"
 }
-# Add any additional variables as needed for other resources.

Commit: adec82a2071159b98d3e935a0c94a0864818c0e5
adec82a variables into pipleine
diff --git a/az-piperh.yml b/az-piperh.yml
index 4f2188c..3f2f9c0 100644
--- a/az-piperh.yml
+++ b/az-piperh.yml
@@ -1,26 +1,33 @@
 # Azure Pipeline that runs basic continuous integration on a Terraform project
 
+# Trigger on specific branches and paths
 trigger:
   branches:
     include:
       - naftest
   paths:
     include:
       - /naftest
 
+# Define repositories
 resources:
   repositories:
     - repository: modules
       type: git
       name: "modules"
 
+# Define variables used in the pipeline
 variables:
+  subscription_id: '7b91df65-1f96-40d9-bcef-a3f85479ad2b'
+  tenant_id: '04986fa2-6d28-46f7-966a-b1ac32f74fa8'
+  org_service_url: 'https://dev.azure.com/NAFTechnologyServices'
   azureLocation: 'us-west-3'
   terraformWorkingDirectory: '$(System.DefaultWorkingDirectory)'
   terraformVersion: $(latest)
 
+# Define pipeline stages
 stages:
   - stage: TerraformContinuousIntegration
     displayName: Terraform Module - CI
     jobs:
       - job: TerraformContinuousIntegrationJob
@@ -44,12 +51,12 @@ stages:
               workingDirectory: $(terraformWorkingDirectory)
               environmentServiceName: $(serviceConnection1)
               terraformVersion: $(latest)
               backendConfig: '-backend-config="access_key=$(SecretKey)"'
             env:
-              ARM_SUBSCRIPTION_ID: $(subscriptionId)
-              ARM_TENANT_ID: $(tenantId)
+              ARM_SUBSCRIPTION_ID: $(subscription_id)
+              ARM_TENANT_ID: $(tenant_id)
 
           # Run Terraform validate
           - task: TerraformCLI@0
             displayName: 'Run terraform validate'
             inputs:
@@ -81,9 +88,5 @@ stages:
               terraformVersion: $(latest)
 
         env:
           PAT_TOKEN: $(PatToken)
           SecretKey: $(KeyVaultSecret)
-
-resources:
-  variables:
-    SecretKey: $(KeyVaultSecret)

Commit: 40d813d897ca4f36d25456c7ba8b1c8eefecfd52
40d813d provider changes
diff --git a/provider.tf b/provider.tf
index ef81dcd..d62f787 100644
--- a/provider.tf
+++ b/provider.tf
@@ -10,27 +10,14 @@ terraform {
     }
   }
 }
 
 provider "azurerm" {
-  subscription_id = "7b91df65-1f96-40d9-bcef-a3f85479ad2b"
-  tenant_id       = "04986fa2-6d28-46f7-966a-b1ac32f74fa8"
+  subscription_id = var.subscription_id
+  tenant_id       = var.tenant_id
   features {}
 }
 
 provider "azuredevops" {
-  org_service_url       = "https://dev.azure.com/NAFTechnologyServices"
-  personal_access_token = "xx"
-}
-
-terraform {
-  backend "azurerm" {
-    resource_group_name  = "TS-Terraform-RG"
-    storage_account_name = "tsterraformsa"
-    container_name       = "dev"
-    key                  = "naftest.terraform.tfstate"
-    subscription_id      = "7b91df65-1f96-40d9-bcef-a3f85479ad2b"
-    tenant_id            = "04986fa2-6d28-46f7-966a-b1ac32f74fa8"
-    client_id            = "72d81d7f-a1f9-4082-9866-5e47ef460908"
-    client_secret        = "xxkR"
-  }
+  org_service_url       = var.org_service_url
+  personal_access_token = var.personal_access_token
 }

Commit: f34d65bb553bcb736f07d0e46243005c9fc114ba
f34d65b embed provider or backend into the pipeline
diff --git a/az-piperh.yml b/az-piperh.yml
index 6055a55..4f2188c 100644
--- a/az-piperh.yml
+++ b/az-piperh.yml
@@ -1,99 +1,89 @@
-# Azure Pipeline that run basic continuous integration on a Terraform project
+# Azure Pipeline that runs basic continuous integration on a Terraform project
 
-# This makes sure the pipeline is triggered every time code is pushed in the validation-testing example source, on all branches.
 trigger:
   branches:
     include:
-    - naftest
+      - naftest
   paths:
     include:
-    - /naftest
+      - /naftest
 
 resources:
   repositories:
     - repository: modules
       type: git
       name: "modules"
 
 variables:
-  # There must be an Azure Service Connection with that name defined in your Azure DevOps settings. See https://docs.microsoft.com/en-us/azure/devops/pipelines/library/connect-to-azure?view=azure-devops
-  serviceConnection1: 'TerraformSC'
-  #serviceconnection2: 'TS-Terraform-Test-SP'
   azureLocation: 'us-west-3'
-  # Terraform settings
   terraformWorkingDirectory: '$(System.DefaultWorkingDirectory)'
   terraformVersion: $(latest)
-  PAT_TOKEN: 'ka4mgn3yyaio3teghpngqlhcfnxupih5aiorgnd2f4dzbmcnramq'
 
 stages:
   - stage: TerraformContinuousIntegration
     displayName: Terraform Module - CI
     jobs:
-    - job: TerraformContinuousIntegrationJob
-      displayName: TerraformContinuousIntegration - CI Job
-      pool:
-        vmImage: ubuntu-20.04
-      steps:
-      - checkout: modules
-      # Step 1: install Checkov Static Code Analysis
-    # Install Checkov
-      - bash: sudo apt install python3-testresources
-      #- bash: pip3 install checkov
-      #  displayName: 'Install checkov'
-      #  name: 'install_checkov'
+      - job: TerraformContinuousIntegrationJob
+        displayName: TerraformContinuousIntegration - CI Job
+        pool:
+          vmImage: ubuntu-20.04
+        steps:
+          - checkout: modules
 
-   #step 2 upgrade pip
-      - bash: python3 -m pip install --upgrade pip
+          # Authenticate to modules repository using PAT
+          - script: git config --global url."https://$(PAT_TOKEN)@dev.azure.com/".insteadOf "https://dev.azure.com/"
+            displayName: 'Authenticate with PAT'
+            env: 
+              PAT_TOKEN: $(PatToken)
 
-    #step 2 authenticate to modules
-      - script: git config --global url."https://$(PAT_TOKEN)@dev.azure.com/".insteadOf "https://dev.azure.com/"
-        displayName: 'Authenticate with PAT'
-        env: 
-          PAT_TOKEN: $(PatToken)
+          # Pass necessary environment variables to Terraform commands
+          - task: TerraformCLI@0
+            displayName: 'Run terraform init'
+            inputs:
+              command: init
+              workingDirectory: $(terraformWorkingDirectory)
+              environmentServiceName: $(serviceConnection1)
+              terraformVersion: $(latest)
+              backendConfig: '-backend-config="access_key=$(SecretKey)"'
+            env:
+              ARM_SUBSCRIPTION_ID: $(subscriptionId)
+              ARM_TENANT_ID: $(tenantId)
+
+          # Run Terraform validate
+          - task: TerraformCLI@0
+            displayName: 'Run terraform validate'
+            inputs:
+              command: validate
+              workingDirectory: $(terraformWorkingDirectory)
+              environmentServiceName: $(serviceConnection1)
+              terraformVersion: $(latest)
 
-    # Step 3: run Terraform init to initialize the workspace
-      - task: TerraformCLI@0
-        displayName: 'Run terraform init'
-        inputs:
-          command: init
-          workingDirectory: $(terraformWorkingDirectory)
-          environmentServiceName: $(serviceConnection1)
-          terraformVersion: $(latest)
-          
-          
+          # Verify module files with Checkov
+          - bash: checkov --directory $(System.DefaultWorkingDirectory)
+            displayName: 'Verify modules with Checkov'
 
-    # Step 4: run Terraform validate to validate HCL syntax
-      - task: TerraformCLI@0
-        displayName: 'Run terraform validate'
-        inputs:
-          command: validate
-          workingDirectory: $(terraformWorkingDirectory)
-          environmentServiceName: $(serviceConnection1)
-          terraformVersion: $(latest)
-          
-          
+          # Run Terraform plan
+          - task: TerraformCLI@0
+            displayName: 'Run terraform plan'
+            inputs:
+              command: plan
+              workingDirectory: $(terraformWorkingDirectory)
+              environmentServiceName: $(serviceConnection1)
+              terraformVersion: $(latest)
 
-    # step 5 Verify module files with Checkov
-      - bash: checkov --directory $(System.DefaultWorkingDirectory)
-        displayName: 'Verify modules with Checkov'
-        name: 'checkov_module_check'
-    
-    # Step 7: run Terraform plan to validate HCL syntax
-      - task: TerraformCLI@0
-        displayName: 'Run terraform plan'
-        inputs:
-          command: plan
-          workingDirectory: $(terraformWorkingDirectory)
-          environmentServiceName: $(serviceConnection1)
-          terraformVersion: $(latest)
-          
+          # Run Terraform apply
+          - task: TerraformCLI@0
+            displayName: 'Run terraform apply'
+            inputs:
+              command: apply
+              workingDirectory: $(terraformWorkingDirectory)
+              environmentServiceName: $(serviceConnection1)
+              terraformVersion: $(latest)
 
-    # Step 8: run Terraform apply to validate HCL syntax
-      - task: TerraformCLI@0
-        displayName: 'Run terraform apply'
-        inputs:
-          command: apply
-          workingDirectory: $(terraformWorkingDirectory)
-          environmentServiceName: $(serviceConnection1)
-          terraformVersion: $(latest)
-          
\ No newline at end of file
+        env:
+          PAT_TOKEN: $(PatToken)
+          SecretKey: $(KeyVaultSecret)
+
+resources:
+  variables:
+    SecretKey: $(KeyVaultSecret)

Commit: 1b8fcbe1173eac66bbb6eed7b53418c6d80c8086
1b8fcbe removed nested keyvault
diff --git a/key_vault.tf b/key_vault.tf
index 5e856eb..872c19c 100644
--- a/key_vault.tf
+++ b/key_vault.tf
@@ -12,32 +12,33 @@ resource "azurerm_key_vault" "key_vault" {
 
   tags = {
     Owner     = var.tag_owner
     Department = var.tag_department
   }
+}
 
-  access_policy {
-    tenant_id = data.azurerm_client_config.current.tenant_id
-    object_id = data.azurerm_client_config.current.object_id
+resource "azurerm_key_vault_access_policy" "key_vault_access_policy" {
+  key_vault_id = azurerm_key_vault.key_vault.id
+  tenant_id    = data.azurerm_client_config.current.tenant_id
+  object_id    = data.azurerm_client_config.current.object_id
 
-    secret_permissions = [
-      "Get",
-      "List",
-      "Set",
-    ]
+  secret_permissions = [
+    "Get",
+    "List",
+    "Set",
+  ]
 
-    key_permissions = [
-      "Get",
-      "List",
-      "Create",
-      "Update",
-      "Import",
-      "Delete",
-      "Recover",
-      "Backup",
-      "Restore",
-      "UnwrapKey",
-    ]
-  }
+  key_permissions = [
+    "Get",
+    "List",
+    "Create",
+    "Update",
+    "Import",
+    "Delete",
+    "Recover",
+    "Backup",
+    "Restore",
+    "UnwrapKey",
+  ]
 }
 
 data "azurerm_client_config" "current" {}

Commit: aaca84d0a1dedd1b5445cf9fcb41730520e77bf5
aaca84d updated providers and moved data blocks to main
diff --git a/main.tf b/main.tf
index 8d4e376..7e34a72 100644
--- a/main.tf
+++ b/main.tf
@@ -1,11 +1,18 @@
+data "azurerm_resource_group" "CORP-LE-NafNet-RG" {
+  name = "CORP-LE-NafNet-RG"
+}
 
-# Configure the Azure provider
-
+data "azuredevops_project" "cloud%architecture%templates" {
+  name = "cloud%architecture%templates"
+}
 
 
-# Include other configuration files for resources
+data "azuredevops_git_repository" "modules" {
+  project_id = data.azuredevops_project.project.id
+  name       = "modules"
+}
 
 module "log_analytics" {
   source = "git::https://$(PAT_TOKEN)@dev.azure.com/NAFTechnologyServices/Cloud%20Architecture%20Templates/modules/_git/modules?ref=naftest&path=log_analytics"
 }
 
@@ -36,8 +43,5 @@ module "key_vault" {
 
 module "storage_account" {
   source = "git::https://$(PAT_TOKEN)@dev.azure.com/NAFTechnologyServices/Cloud%20Architecture%20Templates/modules/_git/modules?ref=naftest&path=storage_account"
 }
 
-# Add any additional configuration or considerations here
-# if they are not covered by separate modules.
-
diff --git a/provider.tf b/provider.tf
index 6546faf..ef81dcd 100644
--- a/provider.tf
+++ b/provider.tf
@@ -1,65 +1,36 @@
 terraform {
   required_providers {
-    
     azurerm = {
-      source = "hashicorp/azurerm"
-      version = "~>2.93.0"
+      source  = "hashicorp/azurerm"
+      version = "~>3.68.0"
     }
-
     azuredevops = {
-      source = "microsoft/azuredevops"
-      version = ">=0.1.0"
+      source  = "microsoft/azuredevops"
+      version = ">=2.51.0"
     }
   }
 }
 
 provider "azurerm" {
   subscription_id = "7b91df65-1f96-40d9-bcef-a3f85479ad2b"
   tenant_id       = "04986fa2-6d28-46f7-966a-b1ac32f74fa8"
-   features {}
+  features {}
 }
 
 provider "azuredevops" {
   org_service_url       = "https://dev.azure.com/NAFTechnologyServices"
   personal_access_token = "xx"
-
-}
-
-data "azurerm_resource_group" "CORP-LE-NafNet-RG" {
-  name = "CORP-LE-NafNet-RG"
-}
-
-#output "name" {
-#  value = data.azurerm_resource_group.CORP-LE-NafNet-RG.name
-#}
-
-data "azuredevops_project" "cloud%architecture%templates" {
-  name = "cloud%architecture%templates"
-}
-
-# Load a specific Git repository by name
-data "azuredevops_git_repository" "modules" {
-  project_id = "data.azuredevops_project.project.id"
-  name       = "modules"
 }
 
-
-#provider "azurerm" {
- #subscription_id = "7b91df65-1f96-40d9-bcef-a3f85479ad2b"
- # tenant_id = 72d81d7f-a1f9-4082-9866-5e47ef460908
- # client_id = 72d81d7f-a1f9-4082-9866-5e47ef460908
- # client_secret = var.client_secret
-
-
 terraform {
   backend "azurerm" {
     resource_group_name  = "TS-Terraform-RG"
     storage_account_name = "tsterraformsa"
     container_name       = "dev"
     key                  = "naftest.terraform.tfstate"
-    subscription_id = "7b91df65-1f96-40d9-bcef-a3f85479ad2b"
-    tenant_id       = "04986fa2-6d28-46f7-966a-b1ac32f74fa8"
-    client_id = "72d81d7f-a1f9-4082-9866-5e47ef460908"
-    client_secret = "xxkR"
+    subscription_id      = "7b91df65-1f96-40d9-bcef-a3f85479ad2b"
+    tenant_id            = "04986fa2-6d28-46f7-966a-b1ac32f74fa8"
+    client_id            = "72d81d7f-a1f9-4082-9866-5e47ef460908"
+    client_secret        = "xxkR"
   }
 }


Coding Standards
Last modified by Axton Grams on 2026/04/24 14:25
________________________________________
This article contains various standards around Terraform IaC (HCL) and Terraform modules.
•	Best Practices and Considerations
o	Support for Multiple AWS Organizations
	Example
o	Support for Multiple AWS Regions
o	Support for Multiple Deployments (name_prefix)
•	Module Naming Conventions
•	Directory Structure
o	Sub-Modules
o	Example Directory
•	File Naming Conventions
o	Specialized files
o	Resources and Data Sources
	AWS Provider
	Other Providers
•	Coding Conventions
o	Argument Grouping
	Examples
o	Working with Sets
	Ordering of Sets
	Example
	Trailing Comma in Sets
o	Working with Variables
	Required Parameters
	Complex Types
	Examples
o	Comments in Code
•	Providers
o	Aliased AWS Providers (regional)
o	Version Constraints
	Root Modules
	Sub-Modules
•	Resource Naming Conventions
o	General Requirements
o	IAM Policies
o	IAM Roles
Best Practices and Considerations
This section contains best practices and considerations. These practices will not apply uniformly in all use cases.
Support for Multiple AWS Organizations
Consider whether a given module needs to function properly in multiple AWS Organizations. If yes, then variable default values should be parameterized by organization to function properly without a manually defined override.
Example
variable "tfc_organization_name" {
  type        = map(string)
  description = "The current TFC organization"

  default = {
    739058867399 = "NYL-Nonprod" # AWS Org education-tech
    500198700114 = "NYL-Prod"    # AWS Org AWS-PAYER
  }
}
Support for Multiple AWS Regions
Consider whether a given module needs to support resource deployments to multiple regions, or to selectively be applied to a single region, which may vary.
When developing a module that needs to deploy resources uniformly across multiple regions, consider using a sub-module that can be called for each region.
•	Create an aliased provider for each AWS Region (e.g., us-east-1, us-east-2)
•	Create a sub-module that can be called for each AWS Region (e.g., /modules/terraform-aws-widget-regional)
•	Pass the aliased provider as the default provider when calling the sub-module
module "widget-us-east-1" {
  source                  = "./modules/terraform-aws-widget-region"

  providers = {
    aws = aws.us-east-1,
  }
}

module "widget-us-east-2" {
  source                  = "./modules/terraform-aws-widget-region"

  providers = {
    aws = aws.us-east-2,
  }
}
Support for Multiple Deployments (name_prefix)
There may be utility with the Terraform module to support multiple deployments within a single AWS Account.  Some AWS Resources have account local and global naming context constraints.  Examples:
•	An AWS S3 Bucket must have a globally unique name
•	An AWS IAM Role must have a name that is unique within an AWS Account
To work around this issue, most Terraform resources support the use of a name prefix, in which a string value is supplied and it is suffixed with random data. This allows multiple deployments with the same name prefix to co-exist in a single AWS Account and avoid global name conflicts.
A name prefix must be used everywhere it is supported.
Module Naming Conventions
The standards established by HashiCorp should be adopted.  See:
•	https://developer.hashicorp.com/terraform/language/style#module-repository-names
The Terraform registry requires that repositories match a naming convention for all modules that you publish to the registry. Module repositories must use this three-part name terraform-<PROVIDER>-<NAME>, where <NAME> reflects the type of infrastructure the module manages and <PROVIDER> is the main provider the module uses. The <NAME> segment can contain additional hyphens, for example, terraform-google-vault or terraform-aws-ec2-instance.
Directory Structure
The following directories should be used for the stated purposes.
Sub-Modules
Sub-modules must be in a separate directory under /modules/.  The directory names should follow the Module Naming Conventions covered in this article.
Sub-modules should not be nested under other sub-modules.
Sub-modules are suitable for use in the following scenarios:
•	Reusable Code: Code that can be called multiple times.
o	Uniform Resources Across Multiple Regions
•	Grouping of Major Features:
o	If a given module services multiple use cases (e.g., terraform-aws-logging manages Security Lake and CloudTrail Organization Trails), features can be organized together using sub-modules
Example Directory
For versioned modules that follow a trunk based flow, /example/ should be used to house a reference implementation of the module call.
File Naming Conventions
This section contains information on file names used in Terraform modules. Consistent rules for the organization of content simplifies the experience for Terraform developers unfamiliar with the module.
Specialized files
The following files are specialized files that can optionally be used in Git repositories for Terraform modules:
•	locals.tf: Used to store all local variables.
•	main.tf or modules.tf: Used for Terraform module calls .
•	outputs.tf: Used for module outputs.
•	providers.tf: Used for provider configuration.
•	variables.tf: Used for all variables.
Resources and Data Sources
IaC for resources and data sources must be housed in a file that reflects the provider and resource/data source type.
AWS Provider
The file name can be obtained by looking at the resources in the Terraform Provider for AWS documentation.
For example, for the aws_ec2_allowed_images_settings resource, it is located under the EC2 service, so it should go into a file named ec2.tf.
 
Examples:
Terraform Resource/Data Source Type	File Name
resource "aws_s3_bucket"	s3.tf
resource "aws_kms_alias"	kms.tf
data "aws_iam_policy"	iam.tf
data "aws_iam_role"	iam.tf
Other Providers
When working with Terraform Providers other than the AWS Provider, resources should be grouped into files that reflect that provider, and optionally the resource type (if there are a large number of resources).
Examples:
Provider	Terraform Resource/Data Source Type	File Name
random	resource "random_uuid"	random.tf or random_uuid.tf
time	resource "time_sleep"	time.tf or time_sleep.tf
time	resource "time_offset"	time.tf or time_offset.tf
Coding Conventions
This section contains norms and conventions for Terraform HCL.
Argument Grouping
When working with blocks and parameters, the following rules must be applied:
•	Single line parameters should be grouped together at the top of the block
•	Multi-line parameters and blocks should be separated by a blank line
Examples
variable "env" {
  description = "SDLC Environment. Allowed Values: test, dev, qa, stage, prod."
  type        = string

  validation {
    condition     = contains(["test", "dev", "qa", "stage", "prod"], var.env)
    error_message = "Invalid env. Allowed values: test, dev, qa, stage, prod."
  }
}
Tings to note on the above code snippet:
•	A blank line (line 4) precedes the validation block (starting on line 5).
•	Two single-line parameters (lines 2 and 3) are grouped together at the top of the variable block (starting on line 1).
module "nyl-custom-amibuilder" {
  source              = "git::https://git.nylcloud.com/Cloud-Team/terraform-aws-nyl-custom-amibuilder.git?ref=main"
  strategic_os_type   = var.strategic_os_type
  strategic_ami_build = var.strategic_ami_build
  env                 = var.env
  lob                 = var.lob
  create_ami          = var.create_ami
  packages            = var.packages
  subnet_tier         = var.subnet_tier
  architecture        = var.architecture
  appid               = var.appid
}
Tings to note on the above code snippet:
•	This block consists of a series of single-line arguments. No blank lines are present in the module block (starting on line 1).
data "aws_ami" "strategic_ami_os_type" {
  most_recent = true
  owners      = local.strategic_ami_owner_accts

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["${var.strategic_os_type}*"]
  }

  filter {
    name   = "description"
    values = ["* - built in the '${var.strategic_ami_build}' Environment"]
  }

  filter {
    name   = "architecture"
    values = [var.architecture]
  }
}
Tings to note on the above code snippet:
•	There are multiple multi-line blocks (starting on lines 5, 10, 15, 20), each separate by a blank line
•	There are multiple single line parameters (lines 2-3) located together at the top of the data block (starting on line 1)
Working with Sets
This section contains rules when working with sets.
Ordering of Sets
In Terraform, a set is an unordered list of values.  In the Terraform HCL (IaC), sets of values should be ordered alphabetically.  This has a number of advantages:
1.	It is easy for a person to locate a value in the set
2.	It is easy to avoid duplicate values in lists
Example
 
variable "map_name" {
  type        = set(string)
  description = "Map of OS Names to Codes"

  default = {
    "NYL Amazon Linux 2023"                  = "cust_al_2023",
    "NYL Amazon Linux 2 Kernel"              = "cust_al_2_kernel",
    "NYL Red Hat Linux 8"                    = "cust_rhl_8",
    "NYL Red Hat Linux 9"                    = "cust_rhl_9",
    "NYL Microsoft Windows Server 2016-v"    = "cust_win_2016",
    "NYL Microsoft Windows Server 2019 core" = "cust_win_2019_core",
    "NYL Microsoft Windows Server 2019-v"    = "cust_win_2019",
    "NYL Microsoft Windows Server 2022 core" = "cust_win_2022_core",
    "NYL Microsoft Windows Server 2022-v"    = "cust_win_2022",
  }
}
Trailing Comma in Sets
A trailing comma on the last entry in the set must be included.  See above for an example.
Advantages:
•	Including the trailing comma results in simpler diffs in the future, making the code review process easier and of better quality
Diff for a change without the trialing comma:
    "NYL Microsoft Windows Server 2019-v"    = "cust_win_2019",
    "NYL Microsoft Windows Server 2022 core" = "cust_win_2022_core",
-   "NYL Microsoft Windows Server 2022-v"    = "cust_win_2022"
+   "NYL Microsoft Windows Server 2022-v"    = "cust_win_2022",
+   "NYL Microsoft Windows Server 2025"      = "cust_win_2025",
  }
}
Diff for the same change with the trailing comma:
    "NYL Microsoft Windows Server 2019-v"    = "cust_win_2019",
    "NYL Microsoft Windows Server 2022 core" = "cust_win_2022_core",
    "NYL Microsoft Windows Server 2022-v"    = "cust_win_2022",
+   "NYL Microsoft Windows Server 2025"      = "cust_win_2025",
  }
}
Working with Variables
This section contains guidance and rules on defining variables.
Required Parameters
Every variable must contain the following parameters:
•	type: Cannot be "any"
•	description: A description for the variable ending with a period.
Complex Types
When working with multiple data points that are related, consider using a complex type to represent the data.  Terraform local variables can be used to reformat, reorder, filter, and perform other manipulations to the data to make it suitable for use within Terraform HCL.
Advantages:
•	A complex variable is easier for a person to read and understand, and subsequently manage, than multiple lists or sets of information that are related.
•	A complex variable can be used to force consistency in the data structure and relationships between different data elements
Examples
variable "ipam_topology" {
  type = map(    # aws account id
    map(object({ # parent pool
      settings = object({
        address_family   = optional(string, "ipv4")
        auto_import      = optional(bool, true)
        cascade          = optional(bool, true)
        description      = string
        cidr_allocations = set(string)
        locale           = optional(string)
      })
      children = optional(map(object({ #regional pool
        settings = object({
          address_family   = optional(string, "ipv4")
          auto_import      = optional(bool, true)
          cascade          = optional(bool, true)
          description      = string
          cidr_allocations = set(string)
          locale           = optional(string)
        })
        sub_pools = optional(map(object({ # transit pools
          settings = object({
            address_family   = optional(string, "ipv4")
            auto_import      = optional(bool, true)
            cascade          = optional(bool, true)
            description      = string
            cidr_allocations = set(string)
            locale           = optional(string)
          })
          env_pools = optional(map(object({ # sdlc pools
            settings = object({
              address_family   = optional(string, "ipv4")
              auto_import      = optional(bool, true)
              cascade          = optional(bool, true)
              description      = string
              cidr_allocations = set(string)
              locale           = optional(string)
            })
          })))
        })), {})
      })))
    }))
  )
  default = {
    "266735837917" = { # nyl-ipam-dev
      "rfc1918-10" = {
        settings = {
          description = "RFC1918 Parent Pool for 10/8"
          cidr_allocations = [
            "10.0.0.0/8",
          ]
        }
        children = { # regional pools
          "us-east-1" = {
            settings = {
              description = "RFC1918-10/8-us-east-1"
              locale      = "us-east-1"

              cidr_allocations = [
                "10.1.0.0/16",
                "10.2.0.0/16",
                "10.3.0.0/16",
                "10.4.0.0/16",
                "10.5.0.0/16",
                "10.10.0.0/16",
                "10.11.0.0/16",
                "10.12.0.0/16",
                "10.13.0.0/16",
                "10.14.0.0/16",
                "10.20.0.0/16",
                "10.21.0.0/16",
                "10.22.0.0/16",
                "10.23.0.0/16",
                "10.24.0.0/16",
                "10.60.0.0/16",
                "10.61.0.0/16",
                "10.62.0.0/16",
                "10.63.0.0/16",
                "10.64.0.0/16",
              ]
            }
            sub_pools = { # transit pools
              "internal" = {
                settings = {
                  description = "RFC1918-us-east-1 internal"
                  locale      = "us-east-1"

                  cidr_allocations = [
                    "10.1.0.0/16",
                    "10.2.0.0/16",
                    "10.3.0.0/16",
                    "10.4.0.0/16",
                    "10.5.0.0/16",
                  ]
                }
                env_pools = { # test, dev, qa stage and prod pools
                  test = {
                    settings = {
                      description = "RFC1918-us-east-1 internal-test"
                      locale      = "us-east-1"

                      cidr_allocations = [
                        "10.5.0.0/16",
                      ]
                    }
                  },
                  dev = {
                    settings = {
                      description = "RFC1918-us-east-1 internal-dev"
                      locale      = "us-east-1"

                      cidr_allocations = [
                        "10.1.0.0/16",
                      ]
                    }
                  },
                  qa = {
                    settings = {
                      description = "RFC1918-us-east-1 internal-qa"
                      locale      = "us-east-1"

                      cidr_allocations = [
                        "10.2.0.0/16",
                      ]
                    }
                  },
                  stage = {
                    settings = {
                      description = "RFC1918-us-east-1 internal-stage"
                      locale      = "us-east-1"

                      cidr_allocations = [
                        "10.3.0.0/16",
                      ]
                    }
                  },
                  prod = {
                    settings = {
                      description = "RFC1918-us-east-1 internal-prod"
                      locale      = "us-east-1"

                      cidr_allocations = [
                        "10.4.0.0/16",
                      ]
                    }
                  }
                }
              },
...
Things to note on the above snippet:
•	This variable supports 4 tiers of data, forming a hierarchy
o	The structure forces the hierarchy to be followed
o	This could be represented in many lists of values, but parsing and understanding that is very difficult.
Comments in Code
•	Commented code will not be merged and will cause delays with Pull Requests.
o	If the code is not active, it should not be merged
•	Comments can be included but should be avoided when possible. Redundant information is noise.
o	E.g,. a comment for a variable should not be required. Variables support a description argument and that should be used instead.
o	Many times, comments are included for a resource but the same information is present in the resource type and resource name, or optionally a description field for the resource.
o	Consider using a more descriptive name for the resource or variable.
	Bad Examples: aws_account_a, aws_account_id_b
	Goo Example: aws_account_id_ipam, aws_account_id_transit
•	An acceptable use for comment is when there is a set of AWS Account IDs.  Example:
variable "organizations_resource_policy" {
  type = map(list(object({
    statements = list(object({
      sid       = optional(string, null)
      effect    = optional(string, null)
      resources = optional(list(string), null)
      actions   = optional(list(string), null)
      principals = optional(list(object({
        type        = string
        identifiers = list(string)
      })), [])
      condition = optional(list(object({
        test     = string
        variable = string
        values   = list(string)
      })), [])
      not_actions   = optional(list(string), null)
      not_resources = optional(list(string), null)
      not_principals = optional(list(object({
        type        = string
        identifiers = list(string)
      })), [])
    }))
  })))
  description = "HCL for AWS IAM Policy for granting access to AWS Organizations"
  default = {
    739058867399 = [ # education-tech
      {
        statements = [
          {
            sid    = "DelegatingNecessaryDescribeListActions"
            effect = "Allow"
            resources = [
              "*",
            ]
            actions = [
              "organizations:DescribeOrganization",
              "organizations:DescribeOrganizationalUnit",
              "organizations:DescribeAccount",
              "organizations:DescribeEffectivePolicy",
              "organizations:ListRoots",
              "organizations:ListOrganizationalUnitsForParent",
              "organizations:ListParents",
              "organizations:ListChildren",
              "organizations:ListAccounts",
              "organizations:ListAccountsForParent",
              "organizations:ListTargetsForPolicy",
              "organizations:ListTagsForResource",
              "organizations:ListAWSServiceAccessForOrganization",
            ]
            principals = [
              {
                type = "AWS",
                identifiers = [
                  "arn:aws:iam::688567286660:root", # nyl-dns-dev
                  "arn:aws:iam::975049945148:root", # nyl-edutesttransit-test
                  "arn:aws:iam::730335309515:root", # nyl-edutesttransit-dev
                  "arn:aws:iam::851725533250:root", # nyl-edutesttransit-qa
                  "arn:aws:iam::471112836611:root", # nyl-edutesttransit-stage
                  "arn:aws:iam::654654358783:root", # nyl-edutesttransit-prod
                  "arn:aws:iam::381492060418:root", # nyl-fms-dev
                  "arn:aws:iam::471112554530:root", # nyl-edutestad-test
                  "arn:aws:iam::637423325729:root", # nyl-edutestimages-test
                  "arn:aws:iam::211125306817:root", # nyl-edutestimages-dev
                  "arn:aws:iam::767398029707:root", # nyl-edutestimages-qa
                  "arn:aws:iam::767398105417:root", # nyl-edutestimages-stage
                  "arn:aws:iam::471112859736:root", # nyl-edutestimages-prod
                  "arn:aws:iam::026090523908:root", # nyl-compoptimizer-dev
                  "arn:aws:iam::266735837917:root", # nyl-ipam-dev
                  "arn:aws:iam::767397956654:root", # nyl-vpcaccess-dev
                ]
              }
            ]
          },
...
Providers
Aliased AWS Providers (regional)
When creating aliased providers for different AWS Regions, the alias name should match the region name, verbatim.  Example:
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"

  default_tags {
    tags = {
      appid = var.appid
    }
  }

  ignore_tags {
    keys = [
      "domain_join",
      "fqdn",
      "nyl:appid",
    ]

    key_prefixes = [
      "cloudaware:",
      "nyl:platform:",
    ]
  }
}
Note that the AWS Provider for us-east-1 has an alias of us-east-1; it is not us_east_1.
Version Constraints
Root Modules
In root modules, the provider version constraint must be pinned to a specific version.
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.8.0"
    }
  }
}
Note line number 7 does not include a logical operator.
Sub-Modules
In all sub-modules, the provider version constrain must use an operator that allows changes to the version, as defined in the root/calling module.
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.8.0"
    }
  }
}
Note line number 7 includes the >= operator.
Resource Naming Conventions
This section contains prescriptive guidance on resource naming conventions. Consistent naming for multipe deployments, unrelated resources, simplifies navigating and reporting on the the myriad of resources in AWS.
General Requirements
Do not use var.lob or var.env in the naming of any resources. Use a generic name, and preferably a name_prefix. Using var.lob and var.env in the name of the resource makes aggregating resources in reports impossible. For example, if a Wiz finding is generated for 100 RDS instances and they all use the same name prefix, they are easy to filter, making the attributing of the finding to an IaC module much easier.
IAM Policies
IAM Policies should model the conventions used by Amazon, which is CamelCase.
If the policy is related to a third party product, the first part of the policy name should be the product name or a representation of the product.  E.g., for Cribl, CriblAccessKMS.
IAM Roles
IAM Policies should model the conventions used by Amazon, which is CamelCase.
If the role is related to a third party product, the first part of the role name should be the product name or a representation of the product.  E.g., for Cribl, CriblAccess.


# Policy: DatabricksClusterPhotonValidator
# Resource type: databricks_cluster
# Checked attribute path: spark_version
# Expected: FAIL because the runtime string contains photon even though runtime_engine is not explicitly set.
# FIX: Added dedicated FAIL coverage for the spark_version Photon branch.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_node_type" "fail_cluster_spark_version_photon" {
  local_disk = true
}

resource "databricks_cluster" "fail_cluster_spark_version_photon" {
  cluster_name  = "fail-cluster-spark-photon"
  spark_version = "14.3.x-scala2.12-photon" # FIX: triggers the spark_version Photon branch
  node_type_id  = data.databricks_node_type.fail_cluster_spark_version_photon.id
  num_workers   = 1
  custom_tags = {
    environment = "dev"
  }
}

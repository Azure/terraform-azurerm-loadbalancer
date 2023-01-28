package unit

import (
	"testing"

	test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func Test_FrontendSubnetIdNotExist(t *testing.T) {
	vars := map[string]interface{}{
		"frontend_subnet_id": "exampleSubnetId",
	}

	test_helper.RunE2ETest(t, "../../", "unit-fixture", terraform.Options{
		Upgrade: true,
		Vars:    vars,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		subnetId, ok := output["subnet_id"].(string)
		require.True(t, ok)
		require.Contains(t, subnetId, "exampleSubnetId")
	})
}

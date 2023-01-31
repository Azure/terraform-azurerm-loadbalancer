package e2e

import (
	"testing"

	test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestExmaples(t *testing.T) {
	testPaths := []string{
		"examples/startup",
		"examples/set_subnet_by_name",
	}

	for _, v := range testPaths {
		t.Run(v, func(t *testing.T) {
			test_helper.RunE2ETest(t, "../../", v, terraform.Options{
				Upgrade: true,
			}, func(t *testing.T, output test_helper.TerraformOutput) {})
		})
	}
}

package e2e

import (
	"testing"

	test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestExamplesStartup(t *testing.T) {
	test_helper.RunE2ETest(t, "../../", "examples/startup", terraform.Options{
		Upgrade: true,
	}, func(t *testing.T, output test_helper.TerraformOutput) {})
}

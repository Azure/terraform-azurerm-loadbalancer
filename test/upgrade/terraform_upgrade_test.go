package e2e

import (
	"testing"

	test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestExamplesUpgrade(t *testing.T) {
	currentRoot, err := test_helper.GetCurrentModuleRootPath()
	if err != nil {
		t.FailNow()
	}
	currentMajorVersion, err := test_helper.GetCurrentMajorVersionFromEnv()
	if err != nil {
		t.FailNow()
	}
	examples := []string{
		"examples/startup",
		"examples/set_subnet_by_name",
	}
	for _, example := range examples {
		e := example
		t.Run(e, func(t *testing.T) {
			test_helper.ModuleUpgradeTest(t, "Azure", "terraform-azurerm-loadbalancer", e, currentRoot, terraform.Options{
				Upgrade: true,
			}, currentMajorVersion)
		})
	}
}

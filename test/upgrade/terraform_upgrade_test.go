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
	}
	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			test_helper.ModuleUpgradeTest(t, "Azure", "terraform-azurerm-loadbalancer", example, currentRoot, terraform.Options{
				Upgrade: true,
			}, currentMajorVersion)
		})
	}
}

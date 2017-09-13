package main

import (
	"flag"
	"fmt"
	"log"
	"os/exec"
	"runtime"
	"strings"
)

var expectedVersion = flag.String("version", "", "Expected Go runtime version.")

func main() {
	flag.Parse()

	if *expectedVersion == "" {
		log.Fatalf("-version flag is required")
	}

	if err := verifyGoVersion(*expectedVersion); err != nil {
		log.Fatal(err)
	}

	if err := verifyInstalledTools(); err != nil {
		log.Fatal(err)
	}

	fmt.Println("Pass!")
}

func verifyGoVersion(version string) error {
	goVer := runtime.Version()

	// Trim the go prefix in the version that is returned.
	goVer = strings.TrimLeft(goVer, "go")

	if strings.Index(version, goVer) < 0 {
		return fmt.Errorf("Go version mismatch, runtime: %s, expected: %s", goVer, version)
	}

	return nil
}

func verifyInstalledTools() error {
	// Check `dep version`
	cmd := exec.Command("dep", "version")
	_, err := cmd.Output()
	return err
}

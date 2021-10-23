#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'

$args = @()
$with = @{
  'in' = "${{ inputs.in }}"; 'out' = "${{ inputs.out }}"; 'icon' = "${{ inputs.icon }}";
  'cp' = "${{ inputs.cp }}"; 'base' = "${{ inputs.base }}"; 'compress' = "${{ inputs.compress }}";
  'resourceid' = "${{ inputs.resourceid }}";
}

ForEach ($key in @($with.Keys)) {
  If (![string]::IsNullOrEmpty($with["$key"])) {
    $is_path = $true

    Switch ($key) {
      { @('in', 'icon') -contains $_} {
        $with["$key"] = Resolve-Path -Path $with["$key"]
      }
      { @('base') -contains $_ } {
        $with["$key"] = Resolve-Path -Path "${{ steps.install.outputs.directory }}\Compiler\$($with["$key"])"
      }
      { @('out') -contains $_ } {
        $with["$key"] = Join-Path $pwd $with["$key"]
        New-Item $(Split-Path -Path $with["$key"]) -Force -ItemType Directory > $null
      }
      default { $is_path = $false }
    }

    If ($is_path) {
      $args += "/$key '$($with["$key"])'"
    } Else {
      $args += "/$key $($with["$key"])"
    }
  }
}

Invoke-Expression "ahk2exe.exe $($args -join ' ')" | Out-String -OutVariable output

$binary = $output.Split([Environment]::NewLine).Where({ $_.contains('exe') })
echo "::set-output name=binary::$binary"
echo "::notice ::Successfully compiled as: ${binary}."

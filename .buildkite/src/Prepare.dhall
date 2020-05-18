-- Autogenerates any pre-reqs for monorepo triage execution
-- Keep these rules lean! They have to run unconditionally.

let Command = ./Command/Dsl.dhall
let Docker = ./Command/Docker/Dsl.dhall
let JobSpec = ./Pipeline/JobSpec.dhall
let Pipeline = ./Pipeline/Dsl.dhall
let Size = ./Command/Size.dhall
let triggerCommand = ./Pipeline/TriggerCommand.dhall

let config : Pipeline.Config.Type = Pipeline.Config::{
  spec = JobSpec::{
    name = "prepare",
    -- TODO: Clean up this code so we don't need an unused dirtyWhen here
    dirtyWhen = ""
  },
  steps = [
    Command.Config::{
      commands = [
        "./.buildkite/scripts/generate-jobs.sh > .buildkite/src/gen/Jobs.dhall",
        triggerCommand "src/Monorepo.dhall"
      ],
      label = "Prepare monorepo triage",
      key = "monorepo",
      target = Size.Small,
      docker = Docker.Config::{ image = (./Constants/ContainerImages.dhall).toolchainBase }
    }
  ]
}
in Pipeline.build config
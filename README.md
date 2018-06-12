# Ruby Docker debug

## Introduction

This repository provides a reference project demonstrating a way to "easily" debug a multi service Ruby stack that is running within docker-compose.

## Conventions

The following conventions are required for the everything to work:

1. There should be a top level docker folder that contains the stacks docker-compose.yml
2. Each service should exist as a sibling folder with a name matching the compose service name

## Getting started

The first thing that you need to do is install the [vscode-ruby](https://github.com/rubyide/vscode-ruby) VS Code extension, I also suggest you install [solargraph](https://github.com/castwide/vscode-solargraph) and include this in your Gemfile, it provides rich intellisense and code completion for Ruby and the two extensions work well together providing a great Ruby development experience.

You will then want to have gems installed locally for your project, this will allow stepping into gem sources to work properly. I attempted to use a volume bind that would be used within the container to install gems but this introduced performance issues on startup for some environments and for now a local `bundle install` is the easiest path and is currently required by extentions like solargraph [anyway](https://github.com/castwide/vscode-solargraph/issues/26).

To start debugging a service next open VS Code in the context of a the service you want to debug `code ./service1`, then open the desired entrypoint file (in the case of the sample that would be `app.rb`), set a breakpoint and then start debugging the service by pressing F5 or Debug->Start Debugging in the menu.

You can also use the `Debug RSpec - xx` profiles to run and debug either all or the actively selected spec file.

# How it works

Each service contains the `launch.json` and `tasks.json` within it's `.vscode` directory, the launch configuration provides configuration for attaching to the remote debugger and configures the pre launch task.

The pre launch task is where the magic happens, these will execute the `bin/ruby-debug-ide` script passing in the compose service name, this script will ensure that the temporary bundle path is created and local gem paths symlinked in, it will then create a compose override exposing the debug ports and override the command to start the specified script under `rdebug-ide`.

Once the debugging session ends it then starts the original compose service back up and everything continues as normal.

## Caveats

Right now the `bin/ruby-debug-ide` start script will create a temp bundle folder within the project workspace `tmp/bundle` and then symlink in your local gem folders into it. The container then overlays the bundle cache volume over this path so that the container has it's own gems while your local has the symlinked paths to your system gem path.

This is what allows stepping into gem sources to work, I have a [merged PR](https://github.com/rubyide/vscode-ruby/pull/350) that once released will remove this hack and only require the container to install gems into the same path that your local gems exist but for now it was the easiest way to get this part working.

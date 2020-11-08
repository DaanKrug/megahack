#!/bin/bash
sudo rm -rf compiled_megahack2020
sudo mkdir compiled_megahack2020
sudo mix do deps.get, deps.compile, compile
sudo MIX_ENV=prod mix release
sudo cp -r _build/prod/rel/ex_app compiled_megahack2020
sudo mv megahack2020.service ./compiled_megahack2020
sudo mv megahack2020_startup.sh ./compiled_megahack2020
sudo mv megahack2020_shutdown.sh ./compiled_megahack2020
sudo mv megahack2020_init.sh ./compiled_megahack2020
sudo chmod +x ./compiled_megahack2020/megahack2020_init.sh

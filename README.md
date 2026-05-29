# ZTeraMax-plugin
This plugins aims to add the Z-Moves, Dynamax and Terastal functionalities to a PSDK fangame

## Useful links

-   [Discord server](https://discord.gg/0noB0gBDd91B8pMk)
-   [Bulbapedia link to Z-Moves](https://bulbapedia.bulbagarden.net/wiki/Z-Move)
-   [Bulbapedia link to Dynamax](https://bulbapedia.bulbagarden.net/wiki/Dynamax)
-   [Bulbapedia link to Terastal](https://bulbapedia.bulbagarden.net/wiki/Terastal_phenomenon)

## How to use

First, it is highly recommended that you use a datapack that you can find [here](https://github.com/PokemonWorkshop/GameDataPacks/tree/gen-packs). Many of the data used in this plugin are erroneous in the base data of Studio project, so most of the functionalities will simply not work.

To use this plugin with your fangame, follow these steps:
  - Download the latest release from this repository
  - Unzip the archive,  you should find a file called `ZTeraMax.psdkplug`.
  - Put this file in the `scripts` folder at the root of your project
  - Make sure to read all this file, there are some steps that are specific to some mechanics (namely, the Terastal needs you to do some file management, if you don't follow the instructions, you will have crashes)
  - Go back to your project's root folder, and run the `cmd.bat` executable, a terminal should open up
  - Enter the command `psdk --util=plugin load` to install the plugin

**Note on move animations**: The Z-Moves and Max-Moves have no animation yet, you can either do them by yourself if you want, or you can wait for someone else to volunteer to do them. Either way, it is useless to complain about them being missing.

## How to update the plugin

### Plugin file update
In the event of an update of the plugin, here are the steps to follow if you already have it installed in your project:
- Go to github [repository](https://github.com/Aelysya/ZTeraMax-plugin)
- Download the latest release
- Replace the ZTeraMax.psdkplug file located in your `scripts` folder with the one you downloaded
- Go back to your project's root folder and run the `cmd.bat` executable, a terminal should open up
- Enter the command `psdk --util=plugin load` to update the plugin

### Configuration file update
In case the configuration file used by the plugin has been updated, follow these steps to avoid overwriting your pre-existing config:

- Go to github [repository](https://github.com/Aelysya/ZTeraMax-plugin)
- Download the latest release
- Open the `z_tera_max_config.json` file in a text editor (like VS Code) and keep the window open
- In your project's folder go in the `Data/configs` folder and open the existing `z_tera_max_config.json` file in your text editor
- Compare the files, if you see new options that are not present in your existing configuration, copy them from the updated version

## Configuration
You may have a custom Battle UI for your fangame, and if so, you may have changed the move selection buttons. By default, this plugins shortens the moves names so they span a maximum of 15 characters. This is to prevent the veeeeeery long Z-Moves names from going out of the window. If you already have a way to deal with this kind of problems or if the shortening isn't necessary for your game, you can go to the config file `Data/configs/z_tera_max_config.json` and modify the value of `useBuiltinMoveNameSlice` to false.

### Z-Moves

Z-Moves have been implemented in the plugin to function as close as possible to the official way, you can have a lot of information about them on the [Bulbapedia page for Z-Moves](https://bulbapedia.bulbagarden.net/wiki/Z-Move)
To use Z-Moves in battle, here's what your players need:
- A Z-tool, which is either a Z-Ring, or a Z-Power Ring
- Some Z-Crystals

When you give a Z-Crystal to your players, be sure to give them one that contains a '2' at the end of their db_symbol (e.g. normalium_z2). In the database these are the bigger crystals. When your players will give a crystal to their Pokémon, it will automatically create the right crystal, which is the smaller version in the database. When they try to retrieve a crystal from their Pokémon, it will not be put back in the bag, just deleted. This mimics the ways these items work in the official games.

### Dynamax

Dynamax has been implemented in the plugin to function as close as possible to the official way, you can have a lot of information about them on the [Bulbapedia page for Dynamax](https://bulbapedia.bulbagarden.net/wiki/Dynamax)
To use the Dynamax in battle, your players will need to be given a Dynamax Band.

By default **ALL** Pokémon will be generated with a 10% chance to have the Gigantamax factor, not only the ones that do have a Gigantamax Form. However, the symbol on the summary will only appear if the Pokémon has a Gigantamax form available, see the GIGANTAMAX_SPECIES array in `2 Dynamax/3 UI/001 Gigantamax Icon Summary.rb` for official Gigantamax species. You can monkey-patch this array to add your custom Gigantamax Pokémon.
The 10% value is customizable, you can change the value of the `gigantamaxChance` in the config file `Data/configs/z_tera_max_config.json`.

To create custom Gigantamax Pokémon, you will have to do a small manipulation of the JSON files. Please note that manipulating the JSON files is a very risky thing to do if you don't **precisely** know what you're doing. So, if you want to add your custom Gigantamax Pokémon, follow exactly these steps:
- Open Pokémon Studio
- Open the database page of the Pokémon you want to give a Gigantamax form to
- Click on "New form" button in the top right corner, edit anything you want
- Click on "Add the form" and remember the number that is shown beside the form's name you just created
- Open the folder that contains your project and follow this folder path: `Data/Studio/pokemon`
- Search for the file that has the name of your Pokémon and open it in a text editor
- Hit CTRL + F keys and enter this: `"form": X,`, replace X by the number you remembered
- Once your text editor shows you the place where this text is, change the number to 40
- **DO NOT TOUCH ANYTHING ELSE IN THE FILE UNLESS YOU KNOW EXACTLY WHAT YOU'RE DOING**, you can modify the sprites from Studio though

To give the Gigantamax factor to a Pokémon (or remove it) you will have to script it by yourself. If you want to follow the official way, check this [link](https://bulbapedia.bulbagarden.net/wiki/Master_Dojo#Max_Soup).
The attribute to modify is `gigantamax_factor`, you can do it by calling `$actors[gv[43]].gigantamax_factor = (true|false)` (check the Motisma devices in the Demo's laboratory for more information on how to modify a Pokémon from an event)

In official games, Dynamax is only allowed in some battles such gym and league challenges. If you want to mimic this, a switch is used to allow or not the use of Dynamax in battle. By default the switch number is 113, this is a completely random choice and may conflict with one your switches, if that's the case, you can change the switch number by going in the config file `Data/configs/z_tera_max_config.json` and modifying the `dynamaxEnabledSwitch` field value.

#### Terastal
Terastal has been implemented in the plugin to function as close as possible to the official way, you can have a lot of information about them on the [Bulbapedia page for Terastal](https://bulbapedia.bulbagarden.net/wiki/Terastal_phenomenon)
To use the Terastal in battle, your players will need to be given a Tera Orb.

To setup the Terastal properly, you'll have to manipulate a few files. This process can't be automated because the plugin adds a new Type and if you already added custom ones to your project there will be some problems. Here are the steps you need to follow depending on your situation:

If you **DID NOT ADD** any new types to your project:
- Paste the `stellar.json` file in the `Data/Studio/types` folder
- Paste the files named `types.png`, `types_fr.png`, `types_en.png` and `types_es.png` in the `graphics/interface` folder, when prompted about it, choose to replace all the files
- Paste the `types_BATTLE.png` file in the `graphics/interface/battle` folder, delete the file named `types.png` in the folder and rename the file you copied to remove the `_BATTLE` part
- Paste the `100003.csv` file in the `Data/Text/Dialogs` folder, when prompted about it, choose to replace the file

If you **DID ADD** new types to your project, open a text editor, you'll need it to modify some of the files:
- In the `Data/Studio/types` folder, open the file of the last type you added to your project. If youre unsure, try looking for the file that has the highest `id` value. Once you found it, open the `stellar.json` file and change its `id` to be 1 more than the number you found
- For the files named `types.png`, `types_fr.png`, `types_en.png` and `types_es.png`, since you already added new types to your project you should know how to handle the case of the new Stellar type, just edit your existing resources to add the Stellar sprites
- For the `types_BATTLE.png` file, same idea as the previous instruction, it just refers to the `types.png` file located in the `graphics/interface/battle` folder
- A new file named `tera_types.png` has been added in the `graphics/interface/battle` folder, you will have to edit it to add your custom types icons. If you don't have the sprites yet, just leave blank spaces of 16 pixels for each of your types between the Fairy and Stellar types
- In the `Data/Text/Dialogs` folder, open the `100003.csv`. Open the same file from the plugin and paste the line containing Stellar texts at the end of your file

By default **ALL** Pokémon will be generated with a 10% chance to have an exotic Tera type. An exotic Tera type is defined as being different from the Pokémon's natural types. 
The 10% value is customizable, you can change the value of the `exoticTeraTypeChance` in the config file `Data/configs/z_tera_max_config.json`.
Note: Ogerpon and Terapagos will always be generated with their Tera type fixed (depends on the mask for Ogerpon, Stellar type for Terapagos).

In official games, Terastal is allowed in every battle, but since the plugin also adds the Dynamax mechanic and there is no overlap between them, you have to decide which mechnic is activated or not. The `terastalEnabledSwitch` field in the `Data/configs/z_tera_max_config.json` file allows you to configure the switch number deciding whether the Terastal is activated or not. If both the Dynamax and the Terastal are activated at the same time, only the Dynamax will be available (because it is more restricted in official games, that way ou could do something like always leaving the Terastal enabled and only modifying the Dynamax switch when you need it).

Another switch number can be configured with the `teraOrbChargeEnabledSwitch` field in the `Data/configs/z_tera_max_config.json` file. It allows you to make it so the Terastal is not limited to one use every Pokémon Center visit. The way it works with the plugin is that after a fight, if the need to recharge is enabled, the switch enabling the Terastal (`terastalEnabledSwitch`) will be set to false. If you want to mimic the way official games work, you can just add a command in your Pokémon Centers to re-set the switch to true when you visit one. In official games the Tera Orb automatically recharges after a battle when you are in some locations or when you capture Terapagos, you can mimic this behaviours with the `teraOrbChargeEnabledSwitch` switch value by setting it to false.

To give modify the Tera type of a Pokémon you will have to script it by yourself. If you want to follow the official way, you 'll need to setup an NPC asking for 50 Tera Shards of a certain type. You can do it by calling `$actors[gv[43]].change_tera_type(:new_type)` (check the Motisma devices in the Demo's laboratory for more information on how to modify a Pokémon from an event)

## Credits

- Main developers:
  - Aelysya
  - Lexio
  - Ota

- Reviewer:
  - Zøzo

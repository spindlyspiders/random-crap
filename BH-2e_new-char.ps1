function roll-dice([string]$dice){
    [int[]]$dice = $dice.split("d")
    $roll = 0
    for ($i=0;$i -lt $dice[0]; $i++){
        $roll += get-random -minimum 1 -maximum ($dice[1]+1)
    }
    $roll
}

function roll-array(){
    $a = roll-dice("2d6")
    $b = roll-dice("1d6")
    $c = roll-dice("2d6")
    $d = roll-dice("1d6")
    $e = roll-dice("2d6")
    $f = roll-dice("1d6")
    $array = ($a-$f+7),($b-$a+14),($c-$b+7),($d-$c+14),($e-$d+7),($f-$e+14)
    $array = $array | sort {get-random}
    $array
}

function choose-class($array){
    $classchoice = @()
    if (3*$array[0] -ge $array[1] + $array[3] + $array[4]){
        $classchoice += "Warrior"
    }
    if (3*$array[1] -ge $array[0] + $array[3] + $array[4]){
        $classchoice += "Thief"
    }
    if (3*$array[3] -ge $array[0] + $array[1] + $array[4]){
        $classchoice += "Wizard"
    }
    if (3*$array[4] -ge $array[0] + $array[1] + $array[3]){
        $classchoice += "Cleric"
    }
    $chooser = roll-dice("1d"+$classchoice.count)
    $classchoice[$chooser -1]
}

function build-warrior(){
    $hp = 6
    $hp += roll-dice("1d4")
    
    $inv = "Invintory:`n"
    $roll = roll-dice("1d6")

    switch ( $roll ) {
        1 { $inv += "    Scalp of an enemy chieftain`n" }
        2 { $inv += "    Vial of widow's tears`n"       }
        3 { $inv += "    My lord's sundered shield`n"   }
        4 { $inv += "    Ears from a goblin tribe`n"    }
        5 { $inv += "    An enemy's heraldric banner`n" }
        6 { $inv += "    A dragon-tooth pendant`n"      }
    }


    $inv += "    Decorative shield displaying my heraldric device`n"
    $roll = roll-dice("1d2")
    if ($roll -eq 1){
        $inv += "    Scale tunic (AV2)`n    Large shield (+1 Armor die)`n    One-handed weapon`n"
        $coins = roll-dice("2d6")
        $inv += "    " + $coins + " coins`n    Unopened orders`n"
    } else {
        $inv += "    Thick hide (AV2)`n    Tin helm (+1 Armor die)`n    Two-handed weapon`n"
        $coins = roll-dice("4d6")
        $inv += "    " + $coins + " coins`n    War paint`n    Book of grudges`n"
    }

    $warrior = "HP:     " + $hp + "`n" + $inv
    $warrior
}

function build-thief(){
    $hp = 2
    $hp += roll-dice("1d6")
    
    $inv = "Invintory:`n"
    $roll = roll-dice("1d6")

    switch ( $roll ) {
        1 { $inv += "    Oversized, moon-shaped coin`n" }
        2 { $inv += "    Bag of knuckle bones`n"        }
        3 { $inv += "    Locket with a portrait`n"      }
        4 { $inv += "    Praying hand tattoo`n"         }
        5 { $inv += "    Eyepatch`n"                    }
        6 { $inv += "    Gold fishook`n"                }
    }


    $inv += "    Disguise of your choosing`n"
    $roll = roll-dice("1d2")
    if ($roll -eq 1){
        $inv += "    Leather hood and vest (AV2)`n    2 short swords`n"
        $coins = roll-dice("2d8")
        $inv += "    " + $coins + " counterfeit coins`n    Stolen heart -- still beating`n"
    } else {
        $inv += "    Cloth gamberson (AV1)`n    Bow and arrows (Ud8)`n"
        $coins = roll-dice("3d6")
        $inv += "    " + $coins + " coins`n    Small, waxy, jade statue of an octopus-man`n"
    }
    
    $thief = "HP:     " + $hp + "`n" + $inv
    $thief
}

function build-cleric(){
    $hp = 4
    $hp += roll-dice("1d6")
    
    $inv = "Invintory:`n"
    $roll = roll-dice("1d6")

    switch ( $roll ) {
        1 { $inv += "    Mummified pointing hand`n"    }
        2 { $inv += "    Ornately engraved crescent`n" }
        3 { $inv += "    Small vial of divine blood`n" }
        4 { $inv += "    Flaming brass hammer`n"       }
        5 { $inv += "    Face made of thorns`n"        }
        6 { $inv += "    Thrice knotted cord`n"        }
    }


    $roll = roll-dice("1d2")
    if ($roll -eq 1){
        $inv += "    Studded hide breastplate (AV2)`n    Flail`n    Shield (+1 Armor die)`n"
        $coins = roll-dice("2d8")
        $inv += "    " + $coins + " coins`n    Forbidden holy scriptures`n"
    } else {
        $inv += "    Thick cloth vestments (AV1)`n    Two-handed hammer`n    Tiny stone box with a voice trapped in it`n"
    }
    
    $prayerbook = "Prayer book:`n"
    $numprayers = 2
    $numprayers += roll-dice("1d4")
    $prayers =  "    Cure light wounds`n","    Detect evil`n","    Light`n","    Protection from evil`n"
    $prayers += "    Purify food and drink`n","    Bless`n","    Find traps`n","    Hold person`n"
    $prayers =  $prayers | sort {get-random}

    for ($i = 0; $i -lt $numprayers; $i++){
        $prayerbook += $prayers[$i]
    }

    $cleric = "HP:     " + $hp + "`n" + $inv + $prayerbook
    $cleric
}


function build-wizard(){
    $hp = 0
    $hp += roll-dice("1d4")
    
    $inv = "Invintory:`n"
    $roll = roll-dice("1d6")

    switch ( $roll ) {
        1 { $inv += "    A 6-inch tall moon-faced man`n"   }
        2 { $inv += "    Spellbook with legs and a tail`n" }
        3 { $inv += "    Three-eyed hummingbird`n"         }
        4 { $inv += "    Small swarm of ladybugs`n"        }
        5 { $inv += "    A toad with human legs`n"         }
        6 { $inv += "    Luminescent crab`n"               }
    }

    
    $roll = roll-dice("1d2")
    if ($roll -eq 1){
        $inv += "    Cloth robes (AV1)`n    Bent oak staff`n    Short sword`n    A void creature's egg`n"
        $coins = roll-dice("2d8")
        $inv += "    " + $coins + " coins`n"
    } else {
        $inv += "    Ceremonial headress (AV1)`n    Angry shrunken head`n"
        $coins = roll-dice("4d6")
        $inv += "    " + $coins + " coins`n    Sacrificial dagger`n"
    }
    
    $spellbook = "Spellbook:`n"
    $numspells = 4
    $numspells += roll-dice("1d4")
    $spells =  "    Charm`n","    Magic missile`n","    Light`n","    Shield`n"
    $spells += "    Sleep`n","    Detect magic`n","    Knock/lock`n","    Web`n"
    $spells =  $spells | sort {get-random}

    for ($i = 0; $i -lt $numspells; $i++){
        $spellbook += $spells[$i]
    }

    $wizard = "HP:     " + $hp + "`n" + $inv + $spellbook
    $wizard
}


$flag = $true
do {
    $n = read-host -prompt "How many characters do you want to generate?"
    if ($n -notmatch "^([0]*(0|[1-9]|[1-9][0-9]|[1-9][0-9][0-9]|1000))$"){
        "Enter an integer between 0 and 1000."
    } else {
        $flag = $false
    }
} while ($flag)
"`n`n`n"
$output = ""

for ($i = 0; $i -lt $n; $i++){
    $array = roll-array
    
    $class = choose-class($array)

    $newchar  = "Number: " + $i.tostring("000")    + "`n"
    $newchar += "Class:  " + $class    + "`n"
    $newchar += "STR:    " + $array[0] + "`n"
    $newchar += "DEX:    " + $array[1] + "`n"
    $newchar += "CON:    " + $array[2] + "`n"
    $newchar += "INT:    " + $array[3] + "`n"
    $newchar += "WIS:    " + $array[4] + "`n"
    $newchar += "CHA:    " + $array[5] + "`n"
    
    switch ( $class ) {
        "Warrior" { $newchar += build-warrior  }
        "Thief"   { $newchar += build-thief    }
        "Cleric"  { $newchar += build-cleric   }
        "Wizard"  { $newchar += build-wizard   }
    }


    $newchar
    
    $output += $newchar + "`n`n"

}



$flag = $true
"`n`n`n"
do {
    $writeout = read-host -prompt "Finished, would you like to write to file? y/n"

    switch ( $writeout ) {
        "y" {
            $output | out-file new-chars.txt
            $flag = $false
        }
        "yes" {
            $output | out-file new-chars.txt
            $flag = $false
        }
        "n" {
            $flag = $false
        }
        "no" {
            $flag = $false
        }
    }

} while ($flag)

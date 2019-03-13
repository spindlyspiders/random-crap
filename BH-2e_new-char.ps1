function Get-DiceRoll {
    [CmdletBinding ()]
    Param([
            Parameter (
                Position = 0,
                Mandatory
            )
        ]
        [string]
        $Dice
    )
    begin {}
    process {
        $DiceCount, $DiceSize = $Dice.Split('d')
        $ValueRange = 1..$DiceSize
        (1..$DiceCount |
            ForEach-Object {
                Get-Random -InputObject $ValueRange
            } | Measure-Object -Sum
        ).Sum
    }

    end {}

    }

function Get-NewStatArray {
    $A = Get-DiceRoll -Dice "2d6"
    $B = Get-DiceRoll -Dice "1d6"
    $C = Get-DiceRoll -Dice "2d6"
    $D = Get-DiceRoll -Dice "1d6"
    $E = Get-DiceRoll -Dice "2d6"
    $F = Get-DiceRoll -Dice "1d6"
    $StatArray = @($A - $F +  7
                   $B - $A + 14
                   $C - $B +  7
                   $D - $C + 14
                   $E - $D +  7
                   $F - $E + 14
                  )
    $StatArray = $StatArray | get-random -count $StatArray.count
    $StatArray
}

function Select-Class {
    [CmdletBinding ()]
    Param([
            Parameter (
                Position = 0,
                Mandatory
            )
        ]
        [array]
        $StatArray
    )
    begin {}
    process {
        $Classes = @()
        if (3*$StatArray[0] -ge $StatArray[1] + $StatArray[3] + $StatArray[4]){
            $Classes += 'Warrior'
        }
        if (3*$StatArray[1] -ge $StatArray[0] + $StatArray[3] + $StatArray[4]){
            $Classes += 'Thief'
        }
        if (3*$StatArray[3] -ge $StatArray[0] + $StatArray[1] + $StatArray[4]){
            $Classes += 'Wizard'
        }
        if (3*$StatArray[4] -ge $StatArray[0] + $StatArray[1] + $StatArray[3]){
            $Classes += 'Cleric'
        }
        $Classes = $Classes | Get-Random -Count 1
        $Classes
    }
    end {}
}

function build-warrior {
    $hp = 6 + (Get-DiceRoll -Dice '1d4')
    
    $inv = "Invintory:`n"

    switch ( Get-DiceRoll -Dice '1d6' ) {
        1 { $inv += "    Scalp of an enemy chieftain`n" }
        2 { $inv += "    Vial of widow’s tears`n"       }
        3 { $inv += "    My lord’s sundered shield`n"   }
        4 { $inv += "    Ears from a goblin tribe`n"    }
        5 { $inv += "    An enemy’s heraldric banner`n" }
        6 { $inv += "    A dragon-tooth pendant`n"      }
    }

    $inv += "    Decorative shield displaying my heraldric device`n"
    switch ( Get-DiceRoll -Dice '1d2' ){
        1 {
            $inv += "    Scale tunic (AV2)`n" +
                    "    Large shield (+1 Armor die)`n" +
                    "    One-handed weapon`n" +
                    '    ' + (Get-DiceRoll -Dice '2d6') + " coins`n" +
                    "    Unopened orders`n"
          }
        2 {
            $inv += "    Thick hide (AV2)`n" +
                    "    Tin helm (+1 Armor die)`n" +
                    "    Two-handed weapon`n" +
                    '    ' + (Get-DiceRoll -Dice '4d6') + " coins`n" +
                    "    War paint`n    Book of grudges`n"
          }
    }

    $warrior = "HP:     " + $hp + "`n" + $inv
    $warrior
}

function build-thief(){
    $hp = 2 + (Get-DiceRoll -Dice '1d6')
    
    $inv = "Invintory:`n"

    switch ( Get-DiceRoll -Dice '1d6' ) {
        1 { $inv += "    Oversized, moon-shaped coin`n" }
        2 { $inv += "    Bag of knuckle bones`n"        }
        3 { $inv += "    Locket with a portrait`n"      }
        4 { $inv += "    Praying hand tattoo`n"         }
        5 { $inv += "    Eyepatch`n"                    }
        6 { $inv += "    Gold fishook`n"                }
    }


    $inv += "    Disguise of your choosing`n"
    switch (Get-DiceRoll -Dice '1d2') {
        1 {
           $inv += "    Leather hood and vest (AV2)`n" +
                   "    2 short swords`n" +
                   '    ' + (Get-DiceRoll -Dice '2d8') + " counterfeit coins`n" +
                   "    Stolen heart -- still beating`n"
          }
        2 {
           $inv += "    Cloth gamberson (AV1)`n" +
                   "    Bow and arrows (Ud8)`n" +
                   '    ' + (Get-DiceRoll -Dice '3d6') + " coins`n" +
                   "    Small, waxy, jade statue of an octopus-man`n"
          }
    }
    
    $thief = 'HP:     ' + $hp + "`n" + $inv
    $thief
}

function build-cleric(){
    $hp = 4 + (Get-DiceRoll -Dice '1d6')
    
    $inv = "Invintory:`n"

    switch ( Get-DiceRoll -Dice '1d6' ) {
        1 { $inv += "    Mummified pointing hand`n"    }
        2 { $inv += "    Ornately engraved crescent`n" }
        3 { $inv += "    Small vial of divine blood`n" }
        4 { $inv += "    Flaming brass hammer`n"       }
        5 { $inv += "    Face made of thorns`n"        }
        6 { $inv += "    Thrice knotted cord`n"        }
    }


    switch (Get-DiceRoll -Dice '1d2') {
        1 {
           $inv += "    Studded hide breastplate (AV2)`n" +
                   "    Flail`n" +
                   "    Shield (+1 Armor die)`n" +
                   '    ' + (Get-DiceRoll -Dice '2d8') + " coins`n    Forbidden holy scriptures`n"
          }
        2 {
           $inv += "    Thick cloth vestments (AV1)`n" +
                   "    Two-handed hammer`n" +
                   "    Tiny stone box with a voice trapped in it`n"
          }
    }

    $prayerbook = "Prayer book:`n "
    $prayers =  @("   Cure light wounds`n"
                  "   Detect evil`n"
                  "   Light`n"
                  "   Protection from evil`n"
                  "   Purify food and drink`n"
                  "   Bless`n"
                  "   Find traps`n"
                  "   Hold person`n"
                 )
    $prayerbook +=  $prayers | get-random -count (2 + (Get-DiceRoll -Dice '1d4'))

    $cleric = 'HP:     ' + $hp + "`n" + $inv + $prayerbook
    $cleric
}


function build-wizard(){
    $hp = (Get-DiceRoll -Dice '1d4')
    $inv = "Invintory:`n"

    switch ( Get-DiceRoll -Dice '1d6' ) {
        1 { $inv += "    A 6-inch tall moon-faced man`n"   }
        2 { $inv += "    Spellbook with legs and a tail`n" }
        3 { $inv += "    Three-eyed hummingbird`n"         }
        4 { $inv += "    Small swarm of ladybugs`n"        }
        5 { $inv += "    A toad with human legs`n"         }
        6 { $inv += "    Luminescent crab`n"               }
    }

    
    switch (Get-DiceRoll -Dice '1d2') {
        1 {
           $inv += "    Cloth robes (AV1)`n" +
                   "    Bent oak staff`n" +
                   "    Short sword`n" +
                   "    A void creature’s egg`n" +
                   '    ' + (Get-DiceRoll -Dice '2d8') + " coins`n"
          }
        2 {
           $inv += "    Ceremonial headress (AV1)`n" +
                   "    Angry shrunken head`n" +
                   '    ' + (Get-DiceRoll -Dice '4d6') + " coins`n" +
                   "    Sacrificial dagger`n"
          }
    }

    $spellbook = "Spellbook:`n "
    $spells = @("   Charm`n"
                "   Magic missile`n"
                "   Light`n"
                "   Shield`n"
                "   Sleep`n"
                "   Detect magic`n"
                "   Knock/lock`n"
                "   Web`n"
               )
    $spellbook +=  $spells | get-random -count (4 + (Get-DiceRoll -Dice '1d4'))


    $wizard = "HP:     " + $hp + "`n" + $inv + $spellbook
    $wizard
}


$flag = $true
do {
    $n = read-host -prompt 'How many characters do you want to generate?'
    if ($n -notin 0..1000){
        'Enter an integer between 0 and 1000.'
    } else {
        $flag = $false
    }
} while ($flag)
"`n`n`n"
$output = ''

for ($i = 0; $i -lt $n; $i++){
    $StatArray = Get-NewStatArray
    
    $class = Select-Class($StatArray)

    $newchar  = 'Number: ' + $i.tostring("000") + "`n" +
                'Class:  ' + $class             + "`n" +
                'STR:    ' + $StatArray[0]      + "`n" +
                'DEX:    ' + $StatArray[1]      + "`n" +
                'CON:    ' + $StatArray[2]      + "`n" +
                'INT:    ' + $StatArray[3]      + "`n" +
                'WIS:    ' + $StatArray[4]      + "`n" +
                'CHA:    ' + $StatArray[5]      + "`n"
    
    switch ( $class ) {
        'Warrior' { $newchar += build-warrior  }
        'Thief'   { $newchar += build-thief    }
        'Cleric'  { $newchar += build-cleric   }
        'Wizard'  { $newchar += build-wizard   }
    }


    $newchar
    
    $output += $newchar + "`n`n"

}



$flag = $true
"`n`n`n"
do {
    $writeout = read-host -prompt 'Finished, would you like to write to file? y/n'

    switch ( $writeout ) {
        'y' {
            $output | out-file new-chars.txt
            $flag = $false
        }
        'yes' {
            $output | out-file new-chars.txt
            $flag = $false
        }
        'n' {
            $flag = $false
        }
        'no' {
            $flag = $false
        }
    }

} while ($flag)

# pipedata3d - piping component data and dimension in 3d.
# Copyright (C) 2015  Shing Liu
#
# pipedata3d is free software. If you think it is useful, 
# you can donate for the author.
#
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# Feedback:
# Please send any bug report, suggestion, question and comment 
# to the author at following address: eryar@163.com

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Tcl script for the Globe Valve of ANSI B16.10 RF.
# 
# Shing Liu(eryar@163.com)
# 
# 2015-03-28 15:00:41 
# 

set aDescription "Globe Valve"

set ::aHeading {
    "Nominal Pipe Size(NPS)" 
    "Half Face to Face(HF)" 
    "HandWheel Height(HH)"
    "HandWheel Diameter(HD)"
    "Flange Thickness(FT)"
    "Flange Diameter(FD)"
}

set ::aDimension {
    RF150 {
        {50 101.6 375 203 20 152}
        {65 107.95 397 203 23 178}
        {80 102.65 419 229 24 191}
        {100 146.05 502 254 24 229}
        {125 177.8 584 356 24 254}
        {150 203.2 651 305 26 279}
        {200 247.65 727 457 29 343}
        {250 311.15 804 610 31 406}
        {300 349.25 1067 914 32 493}
        {350 393.7 1245 914 35 535}
    }
}

# buildChildren --
# 
# build the children for the tree node.
# 
proc buildChildren {theStandardTree theParentNode theId theSource} {
    # the flag for the unique id
    set i 0
    set j 0
    
    dict for {class dimension} $::aDimension {
        set category [$theStandardTree insert $theParentNode end -text $class -tags $theId]
        foreach item $dimension {
            incr j
            $theStandardTree insert $category end -text NPS-[lindex $item 0] -tags "$theId.$i.$j"
            $theStandardTree tag bind "$theId.$i.$j" <1> "selectedItem {$theSource} {$::aHeading} {$item}"
        }
        incr i
    }
}

# buildModel --
# 
# build the model for globe valve.
# 
proc buildModel {theDimension} {
    vclear
    
    # set the DN50 as the default.
    set dn 50
    set hf 101.6
    set hh 375
    set hd 203
    set ft 20
    set fd 152
    
    set dn [lindex $theDimension 0]
    set hf [lindex $theDimension 1]
    set hh [lindex $theDimension 2]
    set hd [lindex $theDimension 3]
    set ft [lindex $theDimension 4]
    set fd [lindex $theDimension 5]
    
    # modeling
    pcylinder aPipe [expr $fd*0.5*0.7] [expr $hf*2.0]
    pcylinder aFlangeIn [expr $fd*0.5] $ft
    pcylinder aFlangeOut [expr $fd*0.5] $ft
    psphere aSphere [expr $hf*0.625] 180
    pcone aCone [expr $hd*0.15*0.5] [expr $hf*0.625] [expr $hh*0.8]
    pcylinder aHandle1 [expr $hf*0.5*1.4] [expr $ft*1.3]
    pcylinder aHandle2 [expr $hd*0.5*0.1] [expr $hh*0.2]
    pcylinder aHandle3 [expr $hd*0.5*0.05] [expr $hd]
    pcylinder aHandle4 [expr $hd*0.5*0.05] [expr $hd]
    ptorus aHandWheel [expr $hd*0.5] [expr $hd*0.5*0.07]
    
    ttranslate aFlangeOut 0 0 [expr $hf*2.0-$ft]
    ttranslate aSphere 0 0 [expr $hf]
    
    trotate aCone 0 0 0 1 0 0 -90
    ttranslate aCone 0 [expr -$hh*0.8] [expr $hf]
    
    trotate aHandle1 0 0 0 1 0 0 -90
    ttranslate aHandle1 0 [expr -($fd*0.5+$ft*1.3)] [expr $hf]
    
    trotate aHandle2 0 0 0 1 0 0 -90
    ttranslate aHandle2 0 -$hh $hf
    
    ttranslate aHandle3 0 -$hh [expr $hf-$hd*0.5]
    
    trotate aHandle4 0 0 0 0 1 0 90
    ttranslate aHandle4 [expr -$hd*0.5] -$hh $hf
    
    trotate aHandWheel 0 0 0 1 0 0 90
    ttranslate aHandWheel 0 -$hh $hf
    
    vdisplay aPipe aFlangeIn aFlangeOut aSphere aCone aHandle1 aHandle2 aHandle3 aHandle4 aHandWheel
    vsetmaterial aPipe aFlangeIn aFlangeOut aSphere aCone aHandle1 aHandle2 aHandle3 aHandle4 aHandWheel steel
    
    #build the dimension for welding neck flange.
    vpoint p1 0 0 0
    vpoint p2 0 0 $hf
    vpoint p3 0 0 $hf*2
    vpoint p4 0 -$hh 0
    
    explode aHandWheel E
    
    vdimension dim1 -length -plane yoz -shapes p1 p2 -flyout -$fd -color black -value $hf
    vdimension dim2 -length -plane yoz -shapes p2 p3 -flyout -$fd -color black -value $hf
    vdimension dim3 -length -plane yoz -shapes p1 p4 -flyout  $fd -color black -value $hh
    vdimension dim5 -diameter -plane yoz -shapes aHandWheel_1 -flyout -$fd -color black -value $hd
    
    # return $aResultShape
}

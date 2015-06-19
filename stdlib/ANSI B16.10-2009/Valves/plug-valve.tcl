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
# to the author at following address: 
#   eryar@163.com

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Tcl script for the Plug Valve #150 FF.
# 
# Shing Liu(eryar@163.com)
# 
# 2015-06-07 20:30:41 
# 

set aDescription "Plug Valve"

set ::aHeading {
    "Nominal Pipe Size(NPS)" 
    "Half Lay Length(HL)" 
    "Centre to Top(CT)"
    "Flange Thickness(FT)"
    "Flange Diameter(FD)"
}

set ::aDimension {
    RF150 {
        {15 66.67 100 11 87}
        {20 66.67 100 13 99}
        {25 69.85 114 14 108}
        {40 82.55 152 18 127}
        {50 95.25 176 19 152}
        {65 104.77 207 22 178}
        {80 114.3 229 24 191}
        {100 114.3 245 24 229}
        {150 196.85 327 25 279}
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
# build the model for plug valve.
# 
proc buildModel {theDimension} {
    vclear
    
    # set the DN50 as the default.
    set dn 50
    set hl 95.25
    set ct 176
    set ft 19
    set fd 152
    
    set dn [lindex $theDimension 0]
    set hl [lindex $theDimension 1]
    set ct [lindex $theDimension 2]
    set ft [lindex $theDimension 3]
    set fd [lindex $theDimension 4]
    
    # modeling
    pcone aValveBody $hl*0.4 $hl*0.6 [expr $ct*0.7 + $fd*0.65]
    pcylinder aCylinder $dn*0.5+10 $hl*2
    pcylinder aLeftFlange $fd*0.5 $ft
    pcylinder aRightFlange $fd*0.5 $ft
    pcylinder aHandle1 $dn*0.1 $ct
    pcylinder aHandle2 $dn*0.1 $ct*2.0
    psphere aHandle3 $dn*0.2
    
    ttranslate aValveBody 0 0 -$fd*0.65
    
    trotate aCylinder 0 0 0 1 0 0 90
    ttranslate aCylinder 0 $hl 0
    
    trotate aLeftFlange 0 0 0 1 0 0 90
    ttranslate aLeftFlange 0 $hl 0
    
    trotate aRightFlange 0 0 0 1 0 0 90
    ttranslate aRightFlange 0 -$hl+$ft 0
    
    trotate aHandle2 0 0 0 0 1 0 90
    ttranslate aHandle2 0 0 $ct
    
    ttranslate aHandle3 0 0 $ct
    
    vdisplay aValveBody aCylinder aLeftFlange aRightFlange aHandle1 aHandle2 aHandle3
    vsetmaterial aValveBody aCylinder aLeftFlange aRightFlange aHandle1 aHandle2 aHandle3 steel
    
    # build the dimension for plug valve.
    vpoint p1 0 -$hl 0
    vpoint p2 0 $hl 0
    
    vpoint p3 0 0 0
    vpoint p4 0 0 $ct
    
    explode aRightFlange E
    
    vdimension dim1 -length -plane yoz -shapes p1 p2 -flyout -$ct -color black -value $hl*2.0
    vdimension dim2 -length -plane zox -shapes p3 p4 -flyout -$hl -color black -value $ct
    vdimension dim3 -diameter -plane zox -shapes aRightFlange_1 -flyout -$hl -color black -value $fd
}

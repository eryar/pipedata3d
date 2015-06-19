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
# Tcl script for the Welding Neck Flange of ASME B16.5-2009.
# 
# Shing Liu(eryar@163.com)
# 
# 2015-02-11 15:50:41 
# 

set aDescription "Welding Neck Flange"

set ::aHeading {
    "Nominal Pipe Size(NPS)" 
    "Outside Diameter of Flange(O)" 
    "Thickness of Flange(tf)"
    "Diameter of Hub(X)"
    "Hub Diameter of Welding Neck(Ah)"
    "Welding Neck(Y)"
    "Welding Bore(B)"
    "Corner Bore Radius(r)"
    "Raised Face Thickness(rf)"
}

set ::aDimension {
    CL150 {
        {15 90 9.6 30 21.3 46 15.8 3 1.6}
        {20 100 11.2 38 26.7 51 20.9 3 1.6}
        {25 110 12.7 49 33.4 54 34.5 3 1.6}
        {50 150 17.5 78 60.3 62 52.5 8 1.6}
        {80 190 22.3 108 88.9 68 77.9 10 1.6}
        {100 230 22.3 135 114.3 75 102.3 11 1.6}
        {150 280 23.9 192 168.3 87 154.1 13 1.6}
    }
    
    CL300 {
        {15 90 9.6 30 21.3 46 15.8 3 1.6}
        {20 100 11.2 38 26.7 51 20.9 3 1.6}
        {25 110 12.7 49 33.4 54 34.5 3 1.6}
        {50 150 17.5 78 60.3 62 52.5 8 1.6}
        {80 190 22.3 108 88.9 68 77.9 10 1.6}
        {100 230 22.3 135 114.3 75 102.3 11 1.6}
        {150 280 23.9 192 168.3 87 154.1 13 1.6}
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
# build the flange model.
# 
proc buildModel {theDimension} {
    vclear
    
    # set the DN15 as the default.
    set dn 15
    set o 90
    set tf 9.6
    set x 30
    set ah 21.3
    set y 46
    set b 15.8
    set r 3
    set rf 1.6
    
    set dn [lindex $theDimension 0]
    set o  [lindex $theDimension 1]
    set tf [lindex $theDimension 2]
    set x  [lindex $theDimension 3]
    set ah [lindex $theDimension 4]
    set y  [lindex $theDimension 5]
    set b  [lindex $theDimension 6]
    set r  [lindex $theDimension 7]
    set rf [lindex $theDimension 8]
    
    # modeling
    pcylinder aRaisedFace [expr $x/2.0] $rf
    pcylinder aFlange [expr $o/2.0] $tf
    pcone aNeck [expr $x/2.0] [expr $ah/2.0] [expr $y-$tf*2.0]
    pcylinder aWeld [expr $ah/2.0] $tf
    pcylinder aSocket [expr $b/2.0] [expr $y+$rf]
    
    nexplode aFlange E
    blend aFlange aFlange $r aFlange_2
    
    renamevar aWeld F
    explode F F
    renamevar F E
    explode E E
    chamf aWeld E E_1 F_1 S $rf
    
    # transform to the right position
    ttranslate aFlange 0 0 $rf
    ttranslate aNeck 0 0 [expr $tf+$rf]
    ttranslate aWeld 0 0 [expr $y+$rf-$tf]
    
    # boolean operations
    bop aRaisedFace aFlange
    bopfuse aResultShape
    
    bop aResultShape aNeck
    bopfuse aResultShape
    
    bop aResultShape aWeld
    bopfuse aResultShape
    
    bop aResultShape aSocket
    bopcut aResultShape

    vdisplay aResultShape
    vsetmaterial -noredraw aResultShape steel
    
    # build the dimension for welding neck flange.
    vpoint p1 0 -[expr $o/2] 0
    vpoint p2 0 [expr $o/2] 0
    
    vpoint p3 0 [expr $o/2] $rf
    vpoint p4 0 [expr $o/2] $y
    
    vpoint p5 0 -[expr $ah/2] $y
    vpoint p6 0 [expr $ah/2] $y
    
    vpoint p7 0 [expr $o/2] [expr $rf+$tf]
    
    explode aSocket E
    
    vdimension dim1 -length -plane yoz -shapes p1 p2 -flyout -$tf -color black -value $o
    vdimension dim2 -length -plane yoz -shapes p3 p4 -flyout -$tf -color black -value $y
    vdimension dim3 -length -plane yoz -shapes p5 p6 -flyout $tf -color black -value $ah
    vdimension dim4 -length -plane yoz -shapes p3 p7 -flyout -$tf/2 -color black -value $tf
    vdimension dim5 -diameter -plane yoz -shapes aSocket_1 -flyout $b -color black -value $b
    
    return $aResultShape
}

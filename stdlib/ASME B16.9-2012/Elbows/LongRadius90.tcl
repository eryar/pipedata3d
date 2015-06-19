# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#
# Script for the Long Radius Elbow of ASME B16.9-2012.
# 
# Shing Liu(eryar@163.com)
# 
# 2015-02-11 16:29:53 
#

set aDescription "Long Radius Elbow 90 Degree"

set ::aHeading {
    "NPS"
    "DN"
    "OutsideDiameter"
    "Center-to-End"
}

set ::aDimension {
    {1/2   15  21.3 38}
    {3/4   20  26.7 38}
    {1     25 33.4 38}
    {1+1/4 32 42.2 48}
    {1+1/2 40 48.3 57}
    {2     50 60.3 76}
    {2+1/2 65 73.0 95}
    {3     80 88.9 114}
    {4    100 114.3 152}
}

proc buildChildren {theStandardTree theParentNode theId theSource} {
    #puts "Long Radius Elbow 90 Degree build children $theId..."
    foreach item $::aDimension {
        incr theId
        $theStandardTree insert $theParentNode end -text NPS-[lindex $item 0] -tags "LR90D$theId"
        $theStandardTree tag bind LR90D$theId <1> "selectedItem {$theSource} {$::aHeading} {$item}"
    }
}

proc buildModel {theDimension} {
    # clear all the model in the 3d viewer.
    vclear
    
    # get dimension
    set nps [lindex $theDimension 0]
    set dn  [lindex $theDimension 1]
    set od  [lindex $theDimension 2]
    set A   [lindex $theDimension 3]
    
    # modeling the elbow.
    ptorus aTorus $A [expr $od/2] 90
    
    renamevar aTorus E
    explode E E
    renamevar E F
    explode F F
    renamevar F aTorus
    
    chamf aResultShape aTorus E_2 F_1 S [expr $od/10]
    chamf aResultShape aResultShape E_3 F_2 S [expr $od/10]
    
    vdisplay aResultShape
    vsetmaterial -noredraw aResultShape steel
    
    # build the dimensions
    vpoint p1 0 0 0
    vpoint p2 $A 0 0
    vdimension dim1 -length -plane xoy -shapes p1 p2 -flyout -15 -color black -value $A
    vdimension dim2 -diameter -plane xoy -shapes E_2 -flyout -15 -color black -value $od
    
    #vrepaint aResultShape
    vtop
}

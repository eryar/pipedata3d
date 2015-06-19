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
# Script for the Straight Tee of ASME B16.9-2012.
# 
# Shing Liu(eryar@163.com)
# 
# 2015-02-11 16:29:53 
#

set aDescription "Straight Tee"

set ::aHeading {
    "Nominal Pipe Size(NPS)"
    "DN"
    "Outisde Diameter"
    "Center-to-End-Run(C)"
    "Center-to-End-Outlet(M)"
}

set ::aDimension {
    {1/2   15  21.3 25 25}
    {3/4   20  26.7 29 29}
    {1     25 33.4 38 38}
    {1+1/4 32 42.2 48 48}
    {1+1/2 40 48.3 57 57}
    {2     50 60.3 64 64}
    {2+1/2 65 73.0 76 76}
    {3     80 88.9 86 86}
    {4    100 114.3 105 105}
}

proc buildChildren {theStandardTree theParentNode theId theSource} {
    set aId 0
    foreach item $::aDimension {
        $theStandardTree insert $theParentNode end -text NPS-[lindex $item 0] -tags "$theId.$aId"
        $theStandardTree tag bind "$theId.$aId" <1> "selectedItem {$theSource} {$::aHeading} {$item}"
        incr theId
    }
}

proc buildModel {theDimension} {
    # clear all the model in the 3d viewer.
    vclear
    
    # get dimension
    set nps [lindex $theDimension 0]
    set dn  [lindex $theDimension 1]
    set od  [lindex $theDimension 2]
    set C   [lindex $theDimension 3]
    set M   [lindex $theDimension 4]
    
    # modeling the elbow.
    set aRadius [expr $od/2]
    pcylinder aRun $aRadius [expr $C*2]
    pcylinder aOutlet $aRadius $M
    
    ttranslate aRun 0 0 -$C
    trotate aOutlet 0 0 0 0 1 0 90
    
    # chamfer the first of run
    renamevar aRun RE
    explode RE E
    renamevar RE RF
    explode RF F
    renamevar RF aRun
    
    chamf aRun aRun RE_1 RF_1 S [expr $od/15]
    
    # chamfer the second of run
    renamevar aRun RE
    explode RE E
    renamevar RE RF
    explode RF F
    renamevar RF aRun
    chamf aRun aRun RE_3 RF_1 S [expr $od/15]
    
    # chamfer the outlet
    renamevar aOutlet RE
    explode RE E
    renamevar RE RF
    explode RF F
    renamevar RF aOutlet
    
    chamf aOutlet aOutlet RE_1 RF_1 S [expr $od/15]
    
    # fuse the run and outlet cylinder.
    bop aRun aOutlet
    bopfuse aResultShape
    
    # display the result shape.
    vdisplay aResultShape
    vsetmaterial -noredraw aResultShape steel
    
    # build the dimensions
    vpoint p1 0 0 0
    vpoint p2 0 0 -$C
    vpoint p3 0 0 $C
    vpoint p4 $M 0 $C
    vdimension dim1 -length -plane zox -shapes p1 p2 -flyout $M -color black -value $C
    vdimension dim2 -length -plane zox -shapes p1 p3 -flyout -$M -color black -value $C
    vdimension dim3 -length -plane zox -shapes p3 p4 -flyout -$C -color black -value $M
    vdimension dim4 -diameter -plane xoy -shapes RE_1 -flyout $M -color black
}

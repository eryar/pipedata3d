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
# Script for the Eccentric Reducer of ASME B16.9-2012.
# 
# Shing Liu(eryar@163.com)
# 
# 2015-03-04 19:29:53 
#

set aDescription "Eccentric Reducer"

set ::aHeading {
    "Nominal Pipe Size(NPS)"
    "Large End"
    "Small End"
    "End-to-End(H)"
}

set ::aDimension {
    {3/4x1/2     26.7 21.3 38}
    {3/4x3/8     26.7 17.3 38}
    {1x1/4       33.4 26.7 51}
    {1x1/2       33.4 21.3 51}
    
    {1+1/4x1     42.2 33.4 51}
    {1+1/4x3/4   42.2 26.7 51}
    {1+1/4x1/2   42.2 21.3 51}
    
    {1+1/2x1+1/4 48.3 42.2 64}
    {1+1/2x1     48.3 33.4 64}
    {1+1/2x3/4   48.3 26.7 64}
    {1+1/2x1/2   48.3 21.3 64}
    
    {2x1+1/2     60.3 48.3 76}
    {2x1+1/4     60.3 42.2 76}
    {2x1         60.3 33.4 76}
    {2x3/4       60.3 26.7 76}
    
    {2+1/2x2     73.0 60.3 89}
    {2+1/2x1+1/2 73.0 48.3 89}
    {2+1/2x1+1/4 73.0 42.2 89}
    {2+1/2x1     73.0 33.4 89}
    
    {3x2+1/2     88.9 73.0 89}
    {3x2         88.9 60.3 89}
    {3x1+1/2     88.9 48.3 89}
    {3x1+1/4     88.9 42.2 89}
    
    {3+1/2x3     101.6 88.9 102}
    {3+1/2x2+1/2 101.6 73.0 102}
    {3+1/2x2     101.6 60.3 102}
    {3+1/2x1+1/2 101.6 48.3 102}
    {3+1/2x1+1/4 101.6 42.2 102}
    
    {4x3+1/2     114.3 101.6 102}
    {4x3         114.3 88.9  102}
    {4x2+1/2     114.3 73.0  102}
    {4x2         114.3 60.3  102}
    {4x1+1/2     114.3 48.3  102}
    
    {20x18       508 457.0 508}
    {20x16       508 406.4 508}
    {20x14       508 355.6 508}
    {20x12       508 323.8 508}
    
    {22x20       559 508.0 508}
    {22x18       559 457.0 508}
    {22x16       559 406.4 508}
    {22x14       559 355.4 508}
    
    {24x22       610 559.0 508}
    {24x20       610 508.0 508}
    {24x18       610 457.0 508}
    {24x16       610 406.4 508}
    
    {26x24       660 610.0 610}
    {26x22       660 559.0 610}
    {26x20       660 508.0 610}
    {26x18       660 457.0 610}
    
    {28x26       711 660.0 610}
    {28x24       711 610.0 610}
    {28x20       711 508.0 610}
    {28x18       711 457.0 610}
    
    {30x28       762 711.0 610}
    {30x26       762 660.0 610}
    {30x24       762 610.0 610}
    {30x20       762 508.0 610}
    
    {32x30       813 762.0 610}
    {32x28       813 711.0 610}
    {32x26       813 660.0 610}
    {32x24       813 610.0 610}
    
    {34x32       864 813.0 610}
    {34x30       864 762.0 610}
    {34x26       864 660.0 610}
    {34x24       864 610.0 610}
}

proc buildChildren {theStandardTree theParentNode theId theSource} {

    set aId 0
    
    foreach item $::aDimension {
        $theStandardTree insert $theParentNode end -text NPS-[lindex $item 0] -tags "$theId.$aId"
        $theStandardTree tag bind "$theId.$aId" <1> "selectedItem {$theSource} {$::aHeading} {$item}"
        incr aId
    }
}

proc buildModel {theDimension} {
    # clear all the model in the 3d viewer.
    vclear
    
    # get dimension
    set nps [lindex $theDimension 0]
    set lo  [lindex $theDimension 1]
    set so  [lindex $theDimension 2]
    set h   [lindex $theDimension 3]
    
    set offset [expr $lo/2-$so/2]
    
    # modeling the reducer
    circle aBottomCircle 0 0 0 $lo/2
    circle aTopCircle 0 $offset $h $so/2
    
    mkedge aBottomEdge aBottomCircle 0 2*pi
    mkedge aTopEdge aTopCircle 0 2*pi
    
    wire aBottomWire aBottomEdge
    wire aTopWire aTopEdge
    
    thrusections aReducer 1 isruled aBottomWire aTopWire

    # make chamfer
    renamevar aReducer E1
    explode E1 E
    renamevar E1 F1
    explode F1 F
    renamevar F1 aReducer
    
    chamf aReducer aReducer E1_1 F1_1 S [expr $so/15]
    
    renamevar aReducer E2
    explode E2 E
    renamevar E2 F2
    explode F2 F
    renamevar F2 aReducer
    
    chamf aReducer aReducer E2_3 F2_1 S [expr $so/15]
    
    vdisplay aReducer
    vsetmaterial -noredraw aReducer steel
    
    # build the dimensions
    vpoint p1 0 0 0
    vpoint p2 0 0 $h
    vdimension dim1 -length -plane yoz -shapes p1 p2 -flyout -$so -color black -value $h
    
    vdimension dim2 -diameter -plane xoy -shapes E1_1 -flyout $so -color black -value $lo
    vdimension dim3 -diameter -plane xoy -shapes E1_3 -flyout $so -color black -value $so
}
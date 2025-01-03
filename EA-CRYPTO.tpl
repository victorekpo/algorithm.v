<chart>
id=133768997668196314
symbol=DOGUSD
description=Dogecoin vs US Dollar
period_type=1
period_size=1
digits=5
tick_size=0.000010
position_time=1730282400
scale_fix=0
scale_fixed_min=0.138420
scale_fixed_max=0.487650
scale_fix11=0
scale_bar=0
scale_bar_val=1.000000
scale=1
mode=1
fore=0
grid=0
volume=0
scroll=1
shift=0
shift_size=2.680067
fixed_pos=0.000000
ticker=1
ohlc=0
one_click=0
one_click_btn=1
bidline=1
askline=0
lastline=0
days=0
descriptions=0
tradelines=1
tradehistory=1
window_left=208
window_top=208
window_right=656
window_bottom=678
window_type=3
floating=0
floating_left=0
floating_top=0
floating_right=0
floating_bottom=0
floating_type=1
floating_toolbar=1
floating_tbstate=
background_color=0
foreground_color=16777215
barup_color=65280
bardown_color=65280
bullcandle_color=0
bearcandle_color=16777215
chartline_color=65280
volumes_color=3329330
grid_color=10061943
bidline_color=10061943
askline_color=255
lastline_color=49152
stops_color=255
windows_total=2

<expert>
name=EA-CRYPTO
path=Experts\Advisors\EA-CRYPTO.ex5
expertmode=1
<inputs>
maxBuyOrders=10
maxSellOrders=10
maxSteps=100
maxOrdersTotal=30
maxReverseBuyOrders=10
maxReverseSellOrders=10
maxLotSize=1000.0
enableHighLotSize=false
forceBuyOrders=false
forceSellOrders=false
forceGap=7
</inputs>
</expert>

<window>
height=130.327869
objects=6

<indicator>
name=Main
path=
apply=1
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=0
fixed_height=-1
</indicator>

<indicator>
name=Moving Average
path=
apply=1
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=0
fixed_height=-1

<graph>
name=
draw=129
style=0
width=3
arrow=251
color=255
</graph>
period=20
method=0
</indicator>

<indicator>
name=Moving Average
path=
apply=1
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=0
fixed_height=-1

<graph>
name=
draw=129
style=0
width=3
arrow=251
color=16711680
</graph>
period=50
method=0
</indicator>

<indicator>
name=Moving Average
path=
apply=1
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=0
fixed_height=-1

<graph>
name=
draw=129
style=0
width=3
arrow=251
color=13850042
</graph>
period=200
method=0
</indicator>

<indicator>
name=Moving Average
path=
apply=1
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=0
fixed_height=-1

<graph>
name=
draw=129
style=0
width=4
arrow=251
color=65535
</graph>
period=9
method=0
</indicator>

<indicator>
name=Moving Average
path=
apply=1
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=0
fixed_height=-1

<graph>
name=
draw=129
style=0
width=3
arrow=251
color=8388736
</graph>
period=250
method=0
</indicator>

<indicator>
name=Moving Average
path=
apply=1
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=0
fixed_height=-1

<graph>
name=
draw=129
style=0
width=3
arrow=251
color=16777215
</graph>
period=500
method=0
</indicator>
<object>
type=32
name=autotrade #5165964154 sell 5K DOGUSD at 0.43688, DOGUSD
hidden=1
descr=NEW_algorithm.V_SellMA
color=1918177
selectable=0
date1=1732426200
value1=0.436880
</object>

<object>
type=31
name=autotrade #5165964510 buy 5K DOGUSD at 0.43680, profit 0.40, DO
hidden=1
color=11296515
selectable=0
date1=1732426255
value1=0.436800
</object>

<object>
type=32
name=autotrade #5165964525 sell 5K DOGUSD at 0.43625, DOGUSD
hidden=1
descr=NEW_algorithm.V_SellMA
color=1918177
selectable=0
date1=1732426257
value1=0.436250
</object>

<object>
type=31
name=autotrade #5165964854 buy 5K DOGUSD at 0.43616, profit 0.45, DO
hidden=1
color=11296515
selectable=0
date1=1732426324
value1=0.436160
</object>

<object>
type=2
name=autotrade #5165964154 -> #5165964510, profit 0.40, DOGUSD
hidden=1
descr=0.43688 -> 0.43680
color=1918177
style=2
selectable=0
ray1=0
ray2=0
date1=1732426200
date2=1732426255
value1=0.436880
value2=0.436800
</object>

<object>
type=2
name=autotrade #5165964525 -> #5165964854, profit 0.45, DOGUSD
hidden=1
descr=0.43625 -> 0.43616
color=1918177
style=2
selectable=0
ray1=0
ray2=0
date1=1732426257
date2=1732426324
value1=0.436250
value2=0.436160
</object>

</window>

<window>
height=19.672131
objects=0

<indicator>
name=Relative Strength Index
path=
apply=1
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=1
scale_fix_min_val=0.000000
scale_fix_max=1
scale_fix_max_val=100.000000
expertmode=0
fixed_height=-1

<graph>
name=
draw=1
style=0
width=1
arrow=251
color=16748574
</graph>

<level>
level=30.000000
style=2
color=12632256
width=1
descr=
</level>

<level>
level=70.000000
style=2
color=12632256
width=1
descr=
</level>
period=14
</indicator>
</window>
</chart>
#time { for i in {1..1250}; do ./ip netns add $i ; done; } &
#time { for i in {1251..2500}; do ./ip netns add $i ; done; } &
#time { for i in {2501..3750}; do ./ip netns add $i ; done; } &
#time { for i in {3751..5000}; do ./ip netns add $i ; done; } &


for i in {1..5000}; do ./ip netns add $i ; done

#time { for i in {1..625}; do ./ip netns add $i ; done; } &
#time { for i in {626..1250}; do ./ip netns add $i ; done; } &
#time { for i in {1251..1875}; do ./ip netns add $i ; done; } &
#time { for i in {1876..2500}; do ./ip netns add $i ; done; } &
#time { for i in {2501..3125}; do ./ip netns add $i ; done; } &
#time { for i in {3126..3750}; do ./ip netns add $i ; done; } &
#time { for i in {3751..4375}; do ./ip netns add $i ; done; } &
#time { for i in {4376..5000}; do ./ip netns add $i ; done; } &

#time { for i in {1..2500}; do ./ip netns add $i ; done; } &
#time { for i in {2501..5000}; do ./ip netns add $i ; done; } &

#time { for i in {1..5000}; do ./ip netns add $i ; done; } &



#time { for i in {1..62}; do ./ip netns add $i ; done; } &
#time { for i in {63..125}; do ./ip netns add $i ; done; } &
#time { for i in {126..187}; do ./ip netns add $i ; done; } &
#time { for i in {188..250}; do ./ip netns add $i ; done; } &
#time { for i in {251..312}; do ./ip netns add $i ; done; } &
#time { for i in {313..375}; do ./ip netns add $i ; done; } &
#time { for i in {376..437}; do ./ip netns add $i ; done; } &
#time { for i in {438..500}; do ./ip netns add $i ; done; } &

#time { for i in {1..312}; do ip netns add $i ; done; } &
#time { for i in {313..625}; do ip netns add $i ; done; } &
#time { for i in {626..936}; do ip netns add $i ; done; } &
#time { for i in {936..1250}; do ip netns add $i ; done; } &
#time { for i in {1251..1563}; do ip netns add $i ; done; } &
#time { for i in {1564..1875}; do ip netns add $i ; done; } &
#time { for i in {1876..2187}; do ip netns add $i ; done; } &
#time { for i in {2188..2500}; do ip netns add $i ; done; } &
#time { for i in {2501..2811}; do ip netns add $i ; done; } &
#time { for i in {2811..3125}; do ip netns add $i ; done; } &
#time { for i in {3126..3435}; do ip netns add $i ; done; } &
#time { for i in {3436..3750}; do ip netns add $i ; done; } &
#time { for i in {3752..4063}; do ip netns add $i ; done; } &
#time { for i in {4064..4375}; do ip netns add $i ; done; } &
#time { for i in {4376..4688}; do ip netns add $i ; done; } &
#time { for i in {4688..5000}; do ip netns add $i ; done; } &

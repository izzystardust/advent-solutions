package main

import (
	"fmt"
	"strconv"
	"strings"
)

func min(a, b int) int {
	if a < b {
		return a
	} else {
		return b
	}
}

func min3(a, b, c int) int {
	return min(min(a, b), c)
}

type box struct {
	l, w, h int
}

func fromString(str string) box {
	vals := strings.Split(str, "x")
	l, _ := strconv.Atoi(vals[0])
	w, _ := strconv.Atoi(vals[1])
	h, _ := strconv.Atoi(vals[2])

	return box{l, w, h}

}

func (b box) surfaceArea() int {
	area := 2*b.l*b.w + 2*b.w*b.h + 2*b.h*b.l
	//fmt.Println("Read area:", area)
	return area
}

func (b box) smallestFaceArea() int {
	dim := min3(b.h*b.w, b.w*b.l, b.l*b.h)
	return dim
}

func (b box) paperNeeded() int {
	return b.surfaceArea() + b.smallestFaceArea()
}

func (b box) perimeters() (int, int, int) {
	return 2*b.h + 2*b.l, 2*b.l + 2*b.w, 2*b.w + 2*b.h
}

func (b box) ribbonNeeded() int {
	return min3(b.perimeters()) + b.h*b.l*b.w
}

func main() {

	paper := 0
	ribbon := 0

	for {
		var b box
		_, err := fmt.Scanf("%dx%dx%d\n", &b.w, &b.h, &b.l)

		if err != nil {
			break
		}

		paper += b.paperNeeded()
		ribbon += b.ribbonNeeded()
	}

	fmt.Println("Paper needed: ", paper)
	fmt.Println("Ribbon needed:", ribbon)
}

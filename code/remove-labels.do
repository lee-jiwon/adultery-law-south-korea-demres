* Drop all value labels and variable labels (comment out if you want the labels)
* Remove all value labels
_strip_labels *

* Remove all variable labels
foreach var of varlist _all {
    label variable `var' ""
}

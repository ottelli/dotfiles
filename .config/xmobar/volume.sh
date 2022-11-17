#!/bin/bash

VOL=$(pamixer --get-volume-human)

echo "<fn=1> $(VOL) </fn>"

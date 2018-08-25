# Setup
```
bundle install
```
# Usage
- max - maximum time for workout
- file - filename in 'input' folder containing json of available exercises

Run
```
ruby start.rb
```
to run with default parameters (file: 'inputs/sample.json', max: 30)

Also there is a possibility to pass additional options
```
ruby start.rb -file 'another_sample.json' -max 10
```
will set file source to specified file name in '/input' folder and max to specified amount

After a successful run, there is output file with same name as input generated in '/output' folder

## Test
```
rspec spec
```

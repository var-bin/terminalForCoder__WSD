# while.sh
#!/bin/bash

again="yes"
while [ "$again" = "yes" ]
do
  echo "Please enter a name:"
  read name
  echo "The name you entered is $name"

  echo "Do you wish to continue? (yes/no)"
  read again
done
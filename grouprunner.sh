#!/bin/bash
source "/home/vineeth/Programs/Anaconda_3/etc/profile.d/conda.sh"
export PATH=/home/vineeth/Programs/Anaconda_3/bin/:$PATH

echo "*** Feedback-FIFO"
cd Feedback-FIFO-RD/
python runner.py configuration1.xls
python runner.py configuration2.xls
python runner.py configuration3.xls
cd ..

echo "*** Feedback-LIFO"
cd Feedback-LIFO-RD/
python runner.py configuration1.xls
python runner.py configuration2.xls
python runner.py configuration3.xls
cd ..

echo "*** Feedback-Random"
cd Feedback-Random-RD/
python runner.py configuration1.xls
python runner.py configuration2.xls
python runner.py configuration3.xls
cd ..

echo "*** NoFeedback FIFO"
cd NoFeedback-FIFO-RD/
python runner.py configuration1.xls
python runner.py configuration2.xls
python runner.py configuration3.xls
cd ..

echo "*** NoFeedback LIFO"
cd NoFeedback-LIFO-RD/
python runner.py configuration1.xls
python runner.py configuration2.xls
python runner.py configuration3.xls
cd ..

echo "*** NoFeedback Random"
cd NoFeedback-Random-RD/
python runner.py configuration1.xls
python runner.py configuration2.xls
python runner.py configuration3.xls
cd ..


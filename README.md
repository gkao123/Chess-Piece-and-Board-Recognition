# Chess-Piece-and-Board-Recognition

This project aims at accurate digital reconstruction of a chess board based off of a user provided image.

Currently, our approach has consisted of using a combination of neural networks for deep learning (Resnet-50) and the use of local feature descriptors such as SIFT/SURF.

# Goals

User takes photo of a chessboard with pieces
Software deconstructs image into individual squares
Software categorizes squares based on the piece assigned to it
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ex: square A4 has a white knight , square g6 is an empty square
Connect a database to the board reconstruction to provide a user with the best next move

# Implementation

I've trained a Mask-RCNN deep learning network, utilizing the code provided by https://github.com/matterport/Mask_RCNN. The dataset we've trained our model (chessboard, chess squares, chess pieces) has been created/annotated by scratch. (For access to the dataset, go into the Mask_RCNN folder).

# Moving Forard
Right now, we've accomplished accurate chessboard, chess piece, and chess square object detection using the detection feature of the network. Our next step moving forward is assigning chess piece to chess square.  The main challenge we've faced is the orientation of the input images. Because the user-provided image can be taken at different angles, having a correct understanding of the orientation of the board is quite difficult. Preliminary work has been done- our current approach is to combine a corner detection approach with contour detection on the mask created for a chessboard.

# Chess-Piece-and-Board-Recognition

This project aims at accurate digital reconstruction of a chess board based off of a visual image.

Currently, our approach has consisted of using a combination of neural networks for deep learning (Resnet-50) and the use of local feature descriptors such as SIFT/SURF.

# Goals

User takes photo of a chessboard with pieces <br />
Software deconstructs image into individual squares <br />
Software categorizes squares based on the piece assigned to it <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ex: square A4 has a white knight , square g6 is an empty square
<br /> Connect a database to the board reconstruction to provide a user with the best next move
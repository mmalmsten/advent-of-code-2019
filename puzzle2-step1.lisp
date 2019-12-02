;;; Split a string into list of integers
(defun comma-split (string)
    (loop for start = 0 then (1+ finish)
        for finish = (position #\, string :start start)
        collecting (parse-integer (subseq string start finish))
        until (null finish)))

;;; Import data from file and convert using comma-split
(defun prepare-data ()
    (defvar input-data (comma-split (with-open-file 
        (stream "/Users/madde/Sites/advent-of-code-2019/input/puzzle2.txt") 
        (read-line stream))))
    (setf (nth 1 input-data) 12)
    (setf (nth 2 input-data) 2)
    input-data)

;;; If the opcode is 1
(defun opcode-one (data i)
    (setf (nth (nth (+ i 3) data) data) 
        (+ (nth (nth (+ i 1) data) data) 
            (nth (nth (+ i 2) data) data))) data)

;;; If the opcode is 2
(defun opcode-two (data i)
    (setf (nth (nth (+ i 3) data) data) 
        (* (nth (nth (+ i 1) data) data) 
            (nth (nth (+ i 2) data) data))) data)

;;; Iterate list
(defun start ()
    (defvar data (prepare-data))
    (let ((i 0))
        (loop while (< i (list-length data)) do
            (if (= (nth i data) 99) 
                (setf i (list-length data))
                (if (= (nth i data) 1) 
                    (setf data (opcode-one data i))
                    (if (= (nth i data) 2)
                        (setf data (opcode-two data i)))))
            (setf i (+ i 4)))) (nth 0 data))
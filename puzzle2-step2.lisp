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
    input-data)

;;; If the opcode is 1 or 2
(defun opcode (data i)
    (setf (nth (nth (+ i 3) data) data) 
        (if (= (nth i data) 1) 
            (+ (nth (nth (+ i 1) data) data) 
                (nth (nth (+ i 2) data) data))
            (if (= (nth i data) 2)
                (* (nth (nth (+ i 1) data) data) 
                    (nth (nth (+ i 2) data) data))))) data)

;;; Iterate list
(defun iterate-list (data noun verb)
    (setf (nth 1 data) noun)
    (setf (nth 2 data) verb)
    (let ((i 0))
        (loop while (< i (list-length data)) do
            (if (= (nth i data) 99) 
                (setf i (list-length data))
                (opcode data i))
            (setf i (+ i 4)))) (nth 0 data))

;;; Try different nouns and verbs
(defun start ()
    (defvar data (prepare-data))
    (defvar result 0)
    (loop for noun from 0 to 99
        do (loop for verb from 0 to 99
            do(setf result (iterate-list (copy-list data) noun verb))
            do(if (= result 19690720) 
                (and (write (+ (* 100 noun) verb)) (return))))))

<!DOCTYPE html>
<html>
<head>
<title>Sci Comms Reliability Calculator</title>
</head>
<body>


<?php
$journal_num = $_POST['journals'];
$predatory_num = $_POST['predatory_num'];
$sci_author = $_POST['author'];
$quote_num = $_POST['quotes'];
$dissent_num = $_POST['dissent'];
$emotion_lang = $_POST['emotion'];
$anecdotal_lang = $_POST['anecdote'];
$type_lang = $_POST['lang'];

$sum = '0'

if ($journal_num = "journals_1") {
  $sum = $sum + 3;
} elseif ($journal_num = "journals_4") {
  $sum = $sum + 5;
} elseif ($journal_num = "journals_7") {
  $sum = $sum + 6;
} else {
  $sum = $sum - 1;
}

if ($predatory_num = "predatory_few") {
  $sum = $sum - ($sum/3);
} elseif ($predatory_most = "predatory_most") {
  $sum = $sum - ($sum/2);
} elseif ($predatory_num = "predatory_all") {
  $sum = $sum -$sum;
} else {
  $sum = $sum;
}

if ($sci_author = "author_y") {
  $sum = $sum + 1;
} else {
  $sum = $sum;
}

if ($quote_num = "quotes_few") {
  $sum = $sum + 1;
} elseif ($quote_num = "quotes_many") {
  $sum = $sum + 2;
} elseif ($quote_num = "quotes_none") {
  $sum = $sum - 1;
} else {
  $sum = $sum;
}

if ($dissent_num = "dissent_few") {
  $sum = $sum + 1;
} elseif ($quote_num = "dissent_many") {
  $sum = $sum + 2;
} else {
  $sum = $sum;
 }

if ($emotion_lang = "emotion_y") {
  $sum = $sum - 1;
} else {
  $sum = $sum;
}

if ($anecdotal_lang = "anecdote_y") {
  $sum = $sum - 1;
} else {
  $sum = $sum;
}

if ($type_lang = "lang_prob") {
  $sum = $sum + 1;
} elseif ($quote_num = "lang_cert") {
  $sum = $sum - 1;
} else {
  $sum = $sum;
}

echo "The final score for this article is:". $sum;
echo "See the table below to find out how reliable this is!".;
?>
</body>
</html>
?> 

$score = 0
$totalQuestions = 0

Write-Host "Welcome to the PowerShell Quiz Game!" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to exit the game at any time.`n" -ForegroundColor Yellow

while ($true) {
    try {
        # Fetch a random question from the Open Trivia Database
        $response = Invoke-RestMethod -Uri "https://opentdb.com/api.php?amount=1&type=multiple"
        $question = $response.results[0]
        
        # Decode HTML entities in the question and answers
        $questionText = [System.Web.HttpUtility]::HtmlDecode($question.question)
        $correctAnswer = [System.Web.HttpUtility]::HtmlDecode($question.correct_answer)
        $incorrectAnswers = $question.incorrect_answers | ForEach-Object { [System.Web.HttpUtility]::HtmlDecode($_) }
        
        # Combine and shuffle all answers
        $allAnswers = @($correctAnswer) + $incorrectAnswers
        $shuffledAnswers = $allAnswers | Sort-Object {Get-Random}
        
        # Display question and answers
        Write-Host "`nCategory: $($question.category)" -ForegroundColor Magenta
        Write-Host "Question: $questionText" -ForegroundColor Green
        Write-Host "`nPossible answers:"
        
        for ($i = 0; $i -lt $shuffledAnswers.Count; $i++) {
            Write-Host "$($i + 1)) $($shuffledAnswers[$i])"
        }
        
        # Get user's answer
        $userAnswer = Read-Host "`nEnter the number of your answer (1-4)"
        
        # Check if the answer is correct
        if ($shuffledAnswers[$userAnswer - 1] -eq $correctAnswer) {
            Write-Host "Correct!" -ForegroundColor Green
            $score++
        } else {
            Write-Host "Wrong! The correct answer was: $correctAnswer" -ForegroundColor Red
        }
        
        $totalQuestions++
        Write-Host "`nCurrent Score: $score / $totalQuestions ($([math]::Round(($score/$totalQuestions)*100))%)`n" -ForegroundColor Yellow
        
        # Small pause between questions
        Start-Sleep -Seconds 2
        
    } catch {
        Write-Host "Error fetching question. Retrying..." -ForegroundColor Red
        Start-Sleep -Seconds 2
    }
}

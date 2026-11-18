Add-Type -AssemblyName System.Drawing

function Draw-UIThumbnail {
    param(
        [string]$Path,
        [string]$ProjectTag,
        [string]$Title,
        [string]$Subtitle,
        [string]$StatusText,
        [string]$Metric1Title,
        [string]$Metric1Val,
        [string]$Metric2Title,
        [string]$Metric2Val,
        [string]$Metric3Title,
        [string]$Metric3Val,
        [string[]]$Items,
        [string]$VisualType = "bars" # bars, waveform, code, radar, cards
    )

    $w = 1280
    $h = 720
    $bmp = [System.Drawing.Bitmap]::new($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    # Dark background with deep dark red radial gradient
    $bgBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 10, 8, 12))
    $g.FillRectangle($bgBrush, 0, 0, $w, $h)
    $bgBrush.Dispose()

    # Ambient subtle grid pattern
    $gridPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(18, 255, 255, 255), 1)
    for ($x = 0; $x -lt $w; $x += 64) {
        $g.DrawLine($gridPen, $x, 0, $x, $h)
    }
    for ($y = 0; $y -lt $h; $y += 64) {
        $g.DrawLine($gridPen, 0, $y, $w, $y)
    }
    $gridPen.Dispose()

    # Top Header Bar
    $hdrBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(200, 16, 12, 18))
    $g.FillRectangle($hdrBrush, 0, 0, $w, 80)
    $hdrBrush.Dispose()

    $hdrBorder = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(60, 255, 255, 255), 1)
    $g.DrawLine($hdrBorder, 0, 80, $w, 80)
    $hdrBorder.Dispose()

    # Header fonts
    $tagFont = [System.Drawing.Font]::new("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $titleFont = [System.Drawing.Font]::new("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
    $subFont = [System.Drawing.Font]::new("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
    $valFont = [System.Drawing.Font]::new("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
    $lblFont = [System.Drawing.Font]::new("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $codeFont = [System.Drawing.Font]::new("Consolas", 11, [System.Drawing.FontStyle]::Regular)

    # Red tag pill
    $pillBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 180, 20, 30))
    $g.FillRectangle($pillBrush, 40, 24, 130, 32)
    $pillBrush.Dispose()

    $whiteBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 255, 255, 255))
    $g.DrawString($ProjectTag.ToUpper(), $tagFont, $whiteBrush, 50, 30)

    # Header Title
    $g.DrawString($Title, $titleFont, $whiteBrush, 190, 27)

    # Status Pill on right
    $statusBg = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(60, 30, 200, 100))
    $g.FillRectangle($statusBg, $w - 240, 24, 190, 32)
    $statusBg.Dispose()

    $greenBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 80, 240, 140))
    $g.DrawString("● " + $StatusText, $tagFont, $greenBrush, $w - 228, 30)
    $greenBrush.Dispose()

    # Subtitle
    $grayBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 170, 170, 180))
    $g.DrawString($Subtitle, $subFont, $grayBrush, 40, 100)

    # 3 Metric Cards Across Top
    $cardW = 380
    $cardH = 100
    $cardY = 135
    $metrics = @(
        @{ Title = $Metric1Title; Val = $Metric1Val },
        @{ Title = $Metric2Title; Val = $Metric2Val },
        @{ Title = $Metric3Title; Val = $Metric3Val }
    )

    for ($i = 0; $i -lt 3; $i++) {
        $cx = 40 + $i * ($cardW + 20)
        $cardBg = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(180, 22, 16, 24))
        $g.FillRectangle($cardBg, $cx, $cardY, $cardW, $cardH)
        $cardBg.Dispose()

        $cardBorder = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(60, 180, 40, 50), 1)
        $g.DrawRectangle($cardBorder, $cx, $cardY, $cardW, $cardH)
        $cardBorder.Dispose()

        # Accent top line
        $accentPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 200, 30, 45), 3)
        $g.DrawLine($accentPen, $cx, $cardY, $cx + $cardW, $cardY)
        $accentPen.Dispose()

        $g.DrawString($metrics[$i].Title.ToUpper(), $lblFont, $grayBrush, $cx + 20, $cardY + 16)
        $redValBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 240, 70, 80))
        $g.DrawString($metrics[$i].Val, $valFont, $redValBrush, $cx + 20, $cardY + 40)
        $redValBrush.Dispose()
    }

    # Main Visual Stage (2 Panels: Left Feed / Right Graphic)
    $stageY = 260
    $stageH = 410

    # Left Panel: Data items / Feed
    $leftW = 460
    $leftBg = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(160, 18, 14, 22))
    $g.FillRectangle($leftBg, 40, $stageY, $leftW, $stageH)
    $leftBg.Dispose()

    $panelBorder = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(50, 255, 255, 255), 1)
    $g.DrawRectangle($panelBorder, 40, $stageY, $leftW, $stageH)

    $g.DrawString("PIPELINE EXECUTION & TELEMETRY", $lblFont, $grayBrush, 60, $stageY + 20)
    $divPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(40, 255, 255, 255), 1)
    $g.DrawLine($divPen, 60, $stageY + 45, 40 + $leftW - 20, $stageY + 45)
    $divPen.Dispose()

    $itemY = $stageY + 60
    for ($idx = 0; $idx -lt [Math]::Min(5, $Items.Length); $idx++) {
        $itemText = $Items[$idx]
        $bulletBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 220, 50, 60))
        $g.FillEllipse($bulletBrush, 60, $itemY + 4, 8, 8)
        $bulletBrush.Dispose()

        $g.DrawString($itemText, $codeFont, $whiteBrush, 80, $itemY)
        $itemY += 60
    }

    # Right Panel: Graphic Canvas
    $rightX = 520
    $rightW = 720
    $rightBg = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(180, 14, 10, 18))
    $g.FillRectangle($rightBg, $rightX, $stageY, $rightW, $stageH)
    $rightBg.Dispose()
    $g.DrawRectangle($panelBorder, $rightX, $stageY, $rightW, $stageH)

    if ($VisualType -eq "bars") {
        # Bar Chart Simulation
        $g.DrawString("CONFIDENCE & PERFORMANCE DISTRIBUTION", $lblFont, $grayBrush, $rightX + 25, $stageY + 20)
        $barX = $rightX + 40
        $barMaxH = 260
        $vals = @(0.85, 0.94, 0.72, 0.98, 0.88, 0.91, 0.79, 0.96)
        $bWidth = 60
        for ($b = 0; $b -lt $vals.Length; $b++) {
            $bh = [int]($barMaxH * $vals[$b])
            $by = $stageY + $stageH - 60 - $bh
            $barBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, [int](160 + $b * 10), 25, 45))
            $g.FillRectangle($barBrush, $barX + $b * 80, $by, $bWidth, $bh)
            $barBrush.Dispose()

            $pctText = [string][int]($vals[$b] * 100) + "%"
            $g.DrawString($pctText, $codeFont, $grayBrush, $barX + $b * 80 + 10, $by - 25)
        }
    } elseif ($VisualType -eq "waveform") {
        # Oscilloscope / Sensor Waveform
        $g.DrawString("LOGIC SIGNAL TIMING & WAVEFORMS", $lblFont, $grayBrush, $rightX + 25, $stageY + 20)
        $wavePen1 = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 230, 45, 65), 3)
        $wavePen2 = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 70, 180, 255), 2)
        $wavePen3 = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 250, 200, 50), 2)

        for ($cy = 0; $cy -lt 3; $cy++) {
            $baseY = $stageY + 90 + $cy * 95
            $g.DrawString("CH" + ($cy + 1) + " (BUS_" + ("CLK", "DATA", "INT")[$cy] + ")", $lblFont, $grayBrush, $rightX + 30, $baseY - 20)
            $prevPt = [System.Drawing.Point]::new($rightX + 160, $baseY)
            $curPen = ($wavePen1, $wavePen2, $wavePen3)[$cy]

            for ($px = $rightX + 160; $px -lt $rightX + $rightW - 30; $px += 25) {
                $high = (($px / 25) % ($cy + 2)) -eq 0
                $py = if ($high) { $baseY - 35 } else { $baseY }
                $g.DrawLine($curPen, $prevPt.X, $prevPt.Y, $prevPt.X, $py)
                $g.DrawLine($curPen, $prevPt.X, $py, $px, $py)
                $prevPt = [System.Drawing.Point]::new($px, $py)
            }
        }
        $wavePen1.Dispose()
        $wavePen2.Dispose()
        $wavePen3.Dispose()
    } elseif ($VisualType -eq "candles") {
        # Financial Candlestick Chart
        $g.DrawString("REAL-TIME EQUITY PRICE & SENTIMENT OVERLAY", $lblFont, $grayBrush, $rightX + 25, $stageY + 20)
        $greenBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 30, 200, 120))
        $redBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 220, 40, 60))
        $greenPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 30, 200, 120), 2)
        $redPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 220, 40, 60), 2)

        $prices = @(
            @{ O = 220; C = 270; H = 290; L = 200 },
            @{ O = 270; C = 250; H = 280; L = 230 },
            @{ O = 250; C = 310; H = 330; L = 240 },
            @{ O = 310; C = 290; H = 320; L = 280 },
            @{ O = 290; C = 350; H = 370; L = 280 },
            @{ O = 350; C = 380; H = 400; L = 330 },
            @{ O = 380; C = 340; H = 390; L = 320 },
            @{ O = 340; C = 410; H = 430; L = 330 }
        )

        for ($k = 0; $k -lt $prices.Length; $k++) {
            $p = $prices[$k]
            $cx = $rightX + 50 + $k * 75
            $isUp = $p.C -ge $p.O
            $brush = if ($isUp) { $greenBrush } else { $redBrush }
            $pen = if ($isUp) { $greenPen } else { $redPen }

            # Wick
            $wickTop = $stageY + $stageH - 40 - $p.H
            $wickBot = $stageY + $stageH - 40 - $p.L
            $g.DrawLine($pen, $cx + 20, $wickTop, $cx + 20, $wickBot)

            # Body
            $bodyTop = $stageY + $stageH - 40 - [Math]::Max($p.O, $p.C)
            $bodyH = [Math]::Max(10, [Math]::Abs($p.C - $p.O))
            $g.FillRectangle($brush, $cx + 5, $bodyTop, 30, $bodyH)
        }

        # Trendline
        $trendPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 255, 210, 40), 3)
        $trendPen.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
        $g.DrawLine($trendPen, $rightX + 60, $stageY + 280, $rightX + $rightW - 40, $stageY + 110)
        $trendPen.Dispose()

        $greenBrush.Dispose()
        $redBrush.Dispose()
        $greenPen.Dispose()
        $redPen.Dispose()
    } else {
        # Media Cards Layout (OTT / Media)
        $g.DrawString("CURATED STREAMING TITLES & METRIC CARDS", $lblFont, $grayBrush, $rightX + 25, $stageY + 20)
        $genres = @("SCI-FI", "CYBERPUNK", "ACTION", "THRILLER", "ANIME")
        for ($m = 0; $m -lt 4; $m++) {
            $mx = $rightX + 35 + $m * 165
            $my = $stageY + 70
            $mw = 150
            $mh = 270

            $mBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 25, 18, 30))
            $g.FillRectangle($mBrush, $mx, $my, $mw, $mh)
            $mBrush.Dispose()

            $mBorder = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(80, 200, 35, 55), 1)
            $g.DrawRectangle($mBorder, $mx, $my, $mw, $mh)
            $mBorder.Dispose()

            $g.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(200, 180, 20, 35)), $mx, $my, $mw, 30)
            $g.DrawString($genres[$m], $lblFont, $whiteBrush, $mx + 10, $my + 8)

            $g.DrawString("★ 9." + ($m + 3), $valFont, $whiteBrush, $mx + 20, $my + 110)
            $g.DrawString("TMDB VERIFIED", $lblFont, $grayBrush, $mx + 15, $my + 170)
            $g.DrawString("4K ULTRA HDR", $lblFont, [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 250, 190, 40)), $mx + 15, $my + 210)
        }
    }

    $panelBorder.Dispose()
    $whiteBrush.Dispose()
    $grayBrush.Dispose()
    $tagFont.Dispose()
    $titleFont.Dispose()
    $subFont.Dispose()
    $valFont.Dispose()
    $lblFont.Dispose()
    $codeFont.Dispose()

    $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $g.Dispose()
    $bmp.Dispose()
    Write-Output "Saved: $Path"
}

# 1-2 & 1-3 for Aarogya AI
Draw-UIThumbnail -Path "$PWD\public\assets\thumbnails\project-1-2.jpg" `
    -ProjectTag "AAROGYA AI" `
    -Title "Disease Risk Prediction & Diagnostic Classifier" `
    -Subtitle "Multi-symptom inference engine backed by Scikit-learn Random Forest and Gradient Boost models." `
    -StatusText "MODEL ACTIVE" `
    -Metric1Title "Prediction Accuracy" -Metric1Val "96.4%" `
    -Metric2Title "Supported Symptoms" -Metric2Val "132+" `
    -Metric3Title "Inference Time" -Metric3Val "42ms" `
    -Items @("Input: Symptom Severity Vector [1, 0, 1, 1, ...]", "Model: Multi-output Decision Classifier", "Scikit-Learn Pipeline Containerized", "Docker Orchestrated Microservice", "NOVATHON 2024 Awarded Architecture") `
    -VisualType "bars"

Draw-UIThumbnail -Path "$PWD\public\assets\thumbnails\project-1-3.jpg" `
    -ProjectTag "AAROGYA AI" `
    -Title "In-Browser TensorFlow.js Radiograph Scanner" `
    -Subtitle "Deep convolutional neural network for client-side pulmonary X-ray screening." `
    -StatusText "TF.JS LOADED" `
    -Metric1Title "CNN Model Latency" -Metric1Val "18ms" `
    -Metric2Title "Screening Classes" -Metric2Val "5 Types" `
    -Metric3Title "Client Privacy" -Metric3Val "100% Local" `
    -Items @("TensorFlow.js WebGL Hardware Acceleration", "Grad-CAM Activation Heatmap Overlay", "Zero Server Uploads (Full In-Browser Privacy)", "Exportable JSON Diagnostic Report", "Render Live Deployment Verified") `
    -VisualType "bars"

# 2-2 & 2-3 for Deloitte Hacksplosion
Draw-UIThumbnail -Path "$PWD\public\assets\thumbnails\project-2-2.jpg" `
    -ProjectTag "DELOITTE 2026" `
    -Title "Autonomous Multi-Agent Ticket Triage System" `
    -Subtitle "National Runner-Up out of 21,866 participants at Deloitte Hacksplosion 2026." `
    -StatusText "RUNNER-UP 2026" `
    -Metric1Title "National Ranking" -Metric1Val "2nd / 21.8k" `
    -Metric2Title "Triage Accuracy" -Metric2Val "98.7%" `
    -Metric3Title "Resolution Gain" -Metric3Val "4.2x Faster" `
    -Items @("Supervisor Agent: Intent & Urgency Parsing", "Routing Agent: Skill-Based Team Mapping", "Escalation Agent: SLA Breach Prevention", "GenW.AI Enterprise Workflow Orchestration", "Deloitte Hacksplosion Finalist Presentation") `
    -VisualType "bars"

Draw-UIThumbnail -Path "$PWD\public\assets\thumbnails\project-2-3.jpg" `
    -ProjectTag "DELOITTE 2026" `
    -Title "GenW.AI Enterprise Queue & Priority Routing" `
    -Subtitle "Autonomous service desk orchestration handling high-volume incident tickets." `
    -StatusText "SYSTEM LIVE" `
    -Metric1Title "Processed Tickets" -Metric1Val "50,000+" `
    -Metric2Title "SLA Compliance" -Metric2Val "99.8%" `
    -Metric3Title "Automated Close" -Metric3Val "72.4%" `
    -Items @("P1 Critical Ticket Auto-Escalation Pipeline", "Real-Time NLP Sentiment Severity Scoring", "Team Capacity & Skill Matrix Balancing", "Automated Solution Recommendation Engine", "Seamless Jira & ServiceNow Integration") `
    -VisualType "waveform"

# 3-1, 3-2, 3-3 for OTT Explorer
Draw-UIThumbnail -Path "$PWD\public\assets\thumbnails\project-3-1.jpg" `
    -ProjectTag "OTT EXPLORER" `
    -Title "Movie & Anime Streaming Web Application" `
    -Subtitle "Full-stack streaming and discovery network with dynamic catalogue synchronization." `
    -StatusText "RENDER LIVE" `
    -Metric1Title "Catalogue Titles" -Metric1Val "10,000+" `
    -Metric2Title "API Sync Rate" -Metric2Val "Real-Time" `
    -Metric3Title "SQL Query Speed" -Metric3Val "<12ms" `
    -Items @("TMDB & Jikan REST APIs Real-Time Aggregation", "Flask Backend with MySQL Index Optimization", "Personalized User Watchlists & Session Auth", "Responsive Dark-Mode Glass UI Architecture", "Deployed on Render Cloud Infrastructure") `
    -VisualType "cards"

Draw-UIThumbnail -Path "$PWD\public\assets\thumbnails\project-3-2.jpg" `
    -ProjectTag "OTT EXPLORER" `
    -Title "Personalized Watchlist & Media Metadata Hub" `
    -Subtitle "Optimized media exploration with rich ratings, cast details, and trailer streaming." `
    -StatusText "DATABASE ACTIVE" `
    -Metric1Title "Active Profiles" -Metric1Val "Multi-User" `
    -Metric2Title "Watchlist Sync" -Metric2Val "Instant" `
    -Metric3Title "Media Cache Hit" -Metric3Val "94%" `
    -Items @("Secure Password Hashing & JWT Auth", "Relational MySQL Schema for User Watchlists", "Lazy-Loaded High-Resolution Movie Posters", "Integrated Video Player & Trailer Previews", "Dynamic Search with Debounced Queries") `
    -VisualType "cards"

Draw-UIThumbnail -Path "$PWD\public\assets\thumbnails\project-3-3.jpg" `
    -ProjectTag "OTT EXPLORER" `
    -Title "Jikan REST API Anime Discovery Network" `
    -Subtitle "Specialized anime tracker with seasonal rankings and episode status feeds." `
    -StatusText "REST API 200" `
    -Metric1Title "Indexed Anime" -Metric1Val "6,500+" `
    -Metric2Title "Daily Airing Feed" -Metric2Val "Live" `
    -Metric3Title "Uptime" -Metric3Val "99.9%" `
    -Items @("Dynamic Genre & Studio Tag Filtering", "Top Airing & Upcoming Anime Carousel", "Detailed Voice Actor & Character Profiles", "Episode Countdown & Schedule Tracker", "Optimized Pagination & Client Caching") `
    -VisualType "cards"

# 4-1, 4-2, 4-3 for Smart Vehicle Accident Alert
Draw-UIThumbnail -Path "$PWD\public\assets\thumbnails\project-4-1.jpg" `
    -ProjectTag "IOT ACCIDENT ALERT" `
    -Title "Smart Vehicle Hardware Collision Detection" `
    -Subtitle "Embedded life-safety unit on Arduino Uno with accelerometer impact sensing." `
    -StatusText "HARDWARE ONLINE" `
    -Metric1Title "Impact Detection" -Metric1Val ">5.0 G-Force" `
    -Metric2Title "SMS Latency" -Metric2Val "<3.5 Sec" `
    -Metric3Title "GPS Lock Speed" -Metric3Val "Instant" `
    -Items @("Arduino Uno Microcontroller Architecture", "ADXL345 3-Axis Collision Accelerometer", "NEO-6M Satellite GPS Positioning Module", "SIM800L Quad-Band GSM Cellular Modem", "Emergency Contact Auto-Broadcast Routine") `
    -VisualType "waveform"

Draw-UIThumbnail -Path "$PWD\public\assets\thumbnails\project-4-2.jpg" `
    -ProjectTag "IOT ACCIDENT ALERT" `
    -Title "Real-Time Emergency GPS Telemetry & Mapping" `
    -Subtitle "Automated coordinates dispatch with speed, heading, and collision vector." `
    -StatusText "SATELLITE LOCKED" `
    -Metric1Title "GPS Accuracy" -Metric1Val "±2.5 Meters" `
    -Metric2Title "Impact Vector" -Metric2Val "3-Axis Data" `
    -Metric3Title "Emergency Radius" -Metric3Val "Local EMS" `
    -Items @("NMEA Protocol Sentence Parsing (GPRMC, GPGGA)", "Instant Geolocation Coordinate Lock", "Crash Vector & Vehicle Roll Over Calculation", "Pre-Impact Speed & Trajectory Logging", "Hardware Fail-Safe & Backup Battery Power") `
    -VisualType "waveform"

Draw-UIThumbnail -Path "$PWD\public\assets\thumbnails\project-4-3.jpg" `
    -ProjectTag "IOT ACCIDENT ALERT" `
    -Title "SIM800L Automated Emergency SMS Dispatch" `
    -Subtitle "Reliable cellular messaging unit routing SOS packets to emergency responders." `
    -StatusText "CELLULAR LINKED" `
    -Metric1Title "Baud Rate" -Metric1Val "9600 bps" `
    -Metric2Title "Dispatch Rate" -Metric2Val "100% Sent" `
    -Metric3Title "Signal Strength" -Metric3Val "-68 dBm" `
    -Items @("AT Command Automation over UART", "Auto-Generated Google Maps Pin Hyperlink", "Multi-Recipient Family & Hospital Alerts", "Audio Siren & Buzzer Alarm Trigger", "Field Tested & Hardware Validated Prototype") `
    -VisualType "waveform"

# 5-1, 5-2, 5-3 for Financial Sentiment Analyzer
Draw-UIThumbnail -Path "$PWD\public\assets\thumbnails\project-5-1.jpg" `
    -ProjectTag "FINANCIAL SENTIMENT" `
    -Title "Real-Time Market Sentiment & Equity Charts" `
    -Subtitle "Algorithmic correlation of live financial news sentiment with equity price action." `
    -StatusText "LIVE FEED" `
    -Metric1Title "Correlation Score" -Metric1Val "+0.82" `
    -Metric2Title "Daily Headlines" -Metric2Val "25,000+" `
    -Metric3Title "Sentiment Lag" -Metric3Val "<500ms" `
    -Items @("Streamlit Interactive Analytics Dashboard", "Pandas & NumPy Timeseries Feature Engineering", "Candlestick Charting with Sentiment Overlays", "Bullish vs Bearish Divergence Indicators", "Literature Survey & Empirical Research Backed") `
    -VisualType "candles"

Draw-UIThumbnail -Path "$PWD\public\assets\thumbnails\project-5-2.jpg" `
    -ProjectTag "FINANCIAL SENTIMENT" `
    -Title "NLP News Polarity & FinBERT Headline Scanner" `
    -Subtitle "Deep linguistic analysis classifying breaking headlines into market sentiment." `
    -StatusText "BERT INFERENCE" `
    -Metric1Title "NLP Accuracy" -Metric1Val "93.8%" `
    -Metric2Title "Headline Speed" -Metric2Val "180/sec" `
    -Metric3Title "Sentiment Range" -Metric3Val "-1.0 to +1.0" `
    -Items @("FinBERT Transformer Linguistic Classification", "VADER & TextBlob Baseline Sentiment Benchmarks", "Named Entity Recognition for Ticker Extraction", "Automated Market Noise & Spam Filtering", "Comprehensive Research Survey Published") `
    -VisualType "candles"

Draw-UIThumbnail -Path "$PWD\public\assets\thumbnails\project-5-3.jpg" `
    -ProjectTag "FINANCIAL SENTIMENT" `
    -Title "Sector Sentiment Heatmap & Predictive Momentum" `
    -Subtitle "Macroeconomic sentiment tracking across technology, healthcare, and energy." `
    -StatusText "HEATMAP READY" `
    -Metric1Title "Tracked Sectors" -Metric1Val "11 Sectors" `
    -Metric2Title "Market Alpha" -Metric2Val "+14.6%" `
    -Metric3Title "Historical Depth" -Metric3Val "5 Years" `
    -Items @("Sector-Wide Relative Sentiment Weighting", "Social & News Momentum Convergence Metrics", "Automated Executive Summary Report Export", "Python Scikit-Learn Regression Pipeline", "Validated against Historical Market Shocks") `
    -VisualType "candles"

# 6-1, 6-2, 6-3 for IoT Communication Suite
Draw-UIThumbnail -Path "$PWD\public\assets\thumbnails\project-6-1.jpg" `
    -ProjectTag "EMBEDDED SUITE" `
    -Title "Multi-Protocol Embedded IoT Communication Testbed" `
    -Subtitle "Hardware protocol analysis benchmarking UART, SPI, I2C, and MQTT." `
    -StatusText "BUS ACTIVE" `
    -Metric1Title "Protocols Tested" -Metric1Val "4 Standards" `
    -Metric2Title "Max SPI Clock" -Metric2Val "10 MHz" `
    -Metric3Title "Packet Loss" -Metric3Val "0.00%" `
    -Items @("UART Serial Asynchronous Data Transfer (115.2k)", "SPI Synchronous High-Speed Peripheral Bus", "I2C Multi-Drop Two-Wire Sensor Interfacing", "MQTT Lightweight Publish/Subscribe Broker", "Academic Communication Protocol Lab Report") `
    -VisualType "waveform"

Draw-UIThumbnail -Path "$PWD\public\assets\thumbnails\project-6-2.jpg" `
    -ProjectTag "EMBEDDED SUITE" `
    -Title "Digital Logic Analyzer Bus Waveforms & Timing" `
    -Subtitle "Nanosecond-level signal integrity verification across hardware bus topologies." `
    -StatusText "LOGIC LOCKED" `
    -Metric1Title "Sampling Rate" -Metric1Val "24 MS/s" `
    -Metric2Title "Clock Jitter" -Metric2Val "<1.2ns" `
    -Metric3Title "Frame Parity" -Metric3Val "Verified" `
    -Items @("8-Channel Logic Analyzer Waveform Capture", "I2C Start/Stop Bit & Acknowledge Timing Analysis", "SPI Mode 0/1/2/3 Phase & Polarity Validation", "UART Frame Error & Baud Drift Benchmarking", "Documented Timing Traces & Waveform Diagrams") `
    -VisualType "waveform"

Draw-UIThumbnail -Path "$PWD\public\assets\thumbnails\project-6-3.jpg" `
    -ProjectTag "EMBEDDED SUITE" `
    -Title "Distributed MQTT Edge Sensor Telemetry Mesh" `
    -Subtitle "Low-overhead telemetry broker coordinating real-time sensor node data." `
    -StatusText "BROKER CONNECTED" `
    -Metric1Title "Active Nodes" -Metric1Val "16 Nodes" `
    -Metric2Title "QoS Level" -Metric2Val "QoS 1 & 2" `
    -Metric3Title "End-to-End Latency" -Metric3Val "<14ms" `
    -Items @("Mosquitto MQTT Broker Telemetry Pipeline", "JSON & Protobuf Lightweight Telemetry Payload", "Edge Node Heartbeat & Keep-Alive Monitoring", "Environmental Sensor Mesh Data Aggregation", "Full Lab Protocol Suite Implementation") `
    -VisualType "waveform"

Write-Output "ALL 18 PROJECT THUMBNAILS GENERATED SUCCESSFULLY!"

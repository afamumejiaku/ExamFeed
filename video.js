var video = document.getElementById('video');

    // Get access to the camera
    if(navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
        navigator.mediaDevices.getUserMedia({ video: true }).then(function(stream) {
            video.srcObject = stream;
            video.play();
        });
    }
    var canvas = document.getElementById('canvas');
    var context = canvas.getContext('2d');
    var video = document.getElementById('video');
    var flag = false;

    document.getElementById("start").addEventListener("click", function() {
        draw();
    });

    document.getElementById("stop").addEventListener("click", function() {
        flag = true;
    });

    function draw() {
        context.drawImage(video, 0, 0, 640, 480)
        if(!flag){
            setTimeout(draw, 2000)
        }
        else{
            context.clearRect(0, 0, 640, 480);
        }
    }

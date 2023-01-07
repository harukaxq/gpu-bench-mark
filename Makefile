build-ffmpeg:
	docker build -t hal256/gpu-bench-mark:ffmpeg -f Dockerfile.ffmpeg .

build-whisper-tiny:
	docker build -t hal256/gpu-bench-mark:tiny --cache-from hal256/gpu-bench-mark:tiny --build-arg MODEL=tiny .

build-whisper-base:
	docker build -t hal256/gpu-bench-mark:base --cache-from hal256/gpu-bench-mark:base --build-arg MODEL=base .
build-whisper-small:
	docker build -t hal256/gpu-bench-mark:small --cache-from hal256/gpu-bench-mark:small --build-arg MODEL=small .
build-whisper-medium:
	docker build -t hal256/gpu-bench-mark:medium --cache-from hal256/gpu-bench-mark:medium --build-arg MODEL=medium .
build-whisper-large:
	docker build -t hal256/gpu-bench-mark:large --cache-from hal256/gpu-bench-mark:large --build-arg MODEL=large .

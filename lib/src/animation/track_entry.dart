/******************************************************************************
 * Spine Runtimes Software License v2.5
 *
 * Copyright (c) 2013-2016, Esoteric Software
 * All rights reserved.
 *
 * You are granted a perpetual, non-exclusive, non-sublicensable, and
 * non-transferable license to use, install, execute, and perform the Spine
 * Runtimes software and derivative works solely for personal or internal
 * use. Without the written permission of Esoteric Software (see Section 2 of
 * the Spine Software License Agreement), you may not (a) modify, translate,
 * adapt, or develop new applications using the Spine Runtimes or otherwise
 * create derivative works or improvements of the Spine Runtimes or (b) remove,
 * delete, alter, or obscure any trademarks or any copyright, trademark, patent,
 * or other intellectual property or proprietary rights notices on or in the
 * Software, including any copy thereof. Redistributions in binary or source
 * form must include this license and terms.
 *
 * THIS SOFTWARE IS PROVIDED BY ESOTERIC SOFTWARE "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL ESOTERIC SOFTWARE BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES, BUSINESS INTERRUPTION, OR LOSS OF
 * USE, DATA, OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
 * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *****************************************************************************/

part of stagexl_spine;

class TrackEntry extends EventDispatcher {

  final int trackIndex;
  final Animation animation;
  final List<bool> timelinesFirst = new List<bool>();
  final List<num> timelinesRotation = new List<num>();

  TrackEntry next;
  TrackEntry mixingFrom;
  bool loop = false;

  double eventThreshold = 0.0;
  double attachmentThreshold = 0.0;
  double drawOrderThreshold = 0.0;
  double animationStart = 0.0;
  double animationEnd = 0.0;
  double animationLast = -1.0;
  double nextAnimationLast = -1.0;
  double trackTime = 0.0;
  double trackLast = -1.0;
  double trackEnd = double.MAX_FINITE;
  double nextTrackLast = -1.0;
  double mixTime = 0.0;
  double mixDuration = 0.0;
  double mixAlpha = 1.0;
  double timeScale = 1.0;
  double delay = 0.0;
  double alpha = 1.0;

  TrackEntry(this.trackIndex, this.animation) {
    this.animationEnd = this.animation.duration;
  }

  //---------------------------------------------------------------------------

  double getAnimationTime() {
    if (loop) {
      double duration = animationEnd - animationStart;
      if (duration == 0.0) return animationStart;
      return trackTime.remainder(duration) + animationStart;
    } else {
      return math.min(trackTime + animationStart, animationEnd);
    }
  }

  EventStream<TrackEntryStartEvent> get onTrackStart {
    return const EventStreamProvider<TrackEntryStartEvent>("start").forTarget(this);
  }

  EventStream<TrackEntryInterruptEvent> get onTrackInterrupt {
    return const EventStreamProvider<TrackEntryInterruptEvent>("interrupt").forTarget(this);
  }

  EventStream<TrackEntryEndEvent> get onTrackEnd {
    return const EventStreamProvider<TrackEntryEndEvent>("end").forTarget(this);
  }

  EventStream<TrackEntryDisposeEvent> get onTrackDispose {
    return const EventStreamProvider<TrackEntryDisposeEvent>("dispose").forTarget(this);
  }

  EventStream<TrackEntryCompleteEvent> get onTrackComplete {
    return const EventStreamProvider<TrackEntryCompleteEvent>("complete").forTarget(this);
  }

  EventStream<TrackEntryEventEvent> get onTrackEvent {
    return const EventStreamProvider<TrackEntryEventEvent>("event").forTarget(this);
  }

  void resetRotationDirection() {
    timelinesRotation.clear();
  }

  @override
  String toString() => animation == null ? "<none>" : animation.name;
}

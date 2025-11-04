$(document).ready(function() {
    // '이용약관' 링크 클릭 시
    $('#open-terms-link').on('click', function(e) {
        e.preventDefault();

		$('#terms-modal .terms-text').load(CONTEXT_PATH + '/terms.do', function() {
			$('#terms-modal').fadeIn();
		 });
	});

     // 개인정보처리방침 클릭 시
    $('#open-privacy-link').on('click', function(e) {
        e.preventDefault();

		$('#privacy-modal .terms-text').load(CONTEXT_PATH + '/privacy.do', function() {
			$('#privacy-modal').fadeIn();
		});
	});

    // 닫기 버튼 또는 모달 바깥 영역 클릭 시
    $('.modal-close-btn, .modal-overlay').on('click', function(e) {
        if ($(e.target).closest('.modal-content').length > 0 && !$(e.target).hasClass('modal-close-btn'))
        {
            return;
        }
        $('#terms-modal').fadeOut();
        $('#privacy-modal').fadeOut();
    });

    
});
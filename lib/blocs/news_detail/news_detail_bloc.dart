import 'dart:async';
import 'package:bestcannedfood_ecommerce/data/repositories/ecommerce_repository.dart';
import 'package:bestcannedfood_ecommerce/model/models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'news_detail_event.dart';
part 'news_detail_state.dart';

class NewsDetailBloc extends Bloc<NewsDetailEvent, NewsDetailState> {
  final EcommerceRepository ecommerceRepository;

  NewsDetailBloc({required this.ecommerceRepository})
      : super(InitialNewsDetailState());

  @override
  Stream<NewsDetailState> mapEventToState(NewsDetailEvent event) async* {
    // Get News Detail
    if (event is NewsDetailRequested) {
      yield* _mapNewsListRequestedToState(event);
    }
  }

  // Get News Detail
  Stream<NewsDetailState> _mapNewsListRequestedToState(
    NewsDetailRequested event,
  ) async* {
    yield NewsDetailLoadInProgress();

    try {
      final News newsDetail =
          await ecommerceRepository.getNewsDetail(event.slug);
      yield NewsDetailLoadSuccess(newsDetail: newsDetail);
    } catch (_) {
      yield NewsDetailLoadFailure();
    }
  }
}
